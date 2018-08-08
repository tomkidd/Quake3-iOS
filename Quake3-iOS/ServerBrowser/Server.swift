//
//  Server.swift
//  ServerQueryLibrary
//
//  Created by Andrea Giavatto on 3/19/14.
//
//

import Foundation

public protocol Server {
    
    var ping: String { get }
    var ip: String { get }
    var port: String { get }
    var originalName: String { get }
    var name: String { get }
    var map: String { get }
    var maxPlayers: String { get }
    var currentPlayers: String { get }
    var mod: String { get }
    var gametype: String { get }
    var rules: [String: String] { get set }
    var players: [Player]? { get set }

    init(ip: String, port: String)
    func update(with serverInfo: [String: String]?, ping: String)
}
