//
//  Q3Parser.swift
//  ServerQueryLibrary
//
//  Created by Andrea Giavatto on 12/14/13.
//
//

import Foundation

class Q3Parser: Parsable {
    
    static func parseServers(_ data: Data) -> [String] {

        if data.count > 0 {

            let len: Int = data.count
            var servers = [String]()
            for i in 0..<len {
                if i > 0 && i % 7 == 0 {
                    // -- 4 bytes for ip, 2 for port, 1 separator
                    let s = data.index(data.startIndex, offsetBy: i-7)
                    let e = data.index(s, offsetBy: 7)
                    let server = parseServerData(data.subdata(in: s..<e))
                    servers.append(server)
                }
            }
            
            return servers
        }
        
        return []
    }

    static func parseServer(_ data: Data) -> [String: String]? {
        
        guard data.count > 0 else {
            return nil
        }
        
        var infoResponse = String(data: data, encoding: .ascii)
        infoResponse = infoResponse?.trimmingCharacters(in: .whitespacesAndNewlines)
        var info = infoResponse?.components(separatedBy: "\\")
        info = info?.filter { NSPredicate(format: "SELF != ''").evaluate(with: $0) }
        var keys = [String]()
        var values = [String]()
        
        if let info = info {
            for (index, element) in info.enumerated() {
                if index % 2 == 0 {
                    keys.append(element)
                } else {
                    values.append(element)
                }
            }
        }
        
        if keys.count == values.count {
            
            var infoDict = [String: String]()
            keys.enumerated().forEach { (i) -> () in
                infoDict[i.element] = values[i.offset]
            }
            
            return infoDict
        }
        
        return nil
    }

    static func parseServerStatus(_ data: Data) -> (rules: [String: String], players: [Player])? {
        
        guard data.count > 0 else {
            return nil
        }
        
        var rules = [String: String]()
        var players = [Q3Player]()
        
        var statusResponse = String(data: data, encoding: .ascii)
        statusResponse = statusResponse?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if let statusComponents = statusResponse?.components(separatedBy: "\n") {
            let serverStatus = statusComponents[0]
            if statusComponents.count > 1 {
                // -- We got players
                let playerStrings = statusComponents[1..<statusComponents.count]
                let playersStatus = Array(playerStrings)
                players = parsePlayersStatus(playersStatus)
            }
            var status = serverStatus.components(separatedBy: "\\")
            status = status.filter { NSPredicate(format: "SELF != ''").evaluate(with: $0) }
            var keys = [String]()
            var values = [String]()
            
            for (index, element) in status.enumerated() {
                if index % 2 == 0 {
                    keys.append(element)
                } else {
                    values.append(element)
                }
            }
            
            if keys.count == values.count {
                
                keys.enumerated().forEach { (i) -> () in
                    rules[i.element] = values[i.offset]
                }
            }
        }
        
        return (rules, players)
    }

    // MARK: - Private methods

    private static func parseServerData(_ data: Data) -> String {

        let len: Int = data.count
        let bytes = [UInt8](data)
        var port: UInt32 = 0
        var server = String()
        for i in 0..<len - 1 {

            if i < 4 {
                if i < 3 {
                    server = server.appendingFormat("%d.", bytes[i])
                }
                else {
                    server = server.appendingFormat("%d", bytes[i])
                }
            }
            else {
                if i == 4 {
                    port += UInt32(bytes[i]) << 8
                }
                else {
                    port += UInt32(bytes[i])
                }
            }
        }
        return "\(server):\(port)"
    }

    private static func parsePlayersStatus(_ players: [String]) -> [Q3Player] {
        
        guard players.count > 0 else {
            return []
        }
        
        var q3Players = [Q3Player]()
        
        for playerString in players {
            if let player = Q3Player(line: playerString) {
                q3Players.append(player)
            }
        }

        return q3Players
    }
}
