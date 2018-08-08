//
//  Game.swift
//  Q3ServerBrowser
//
//  Created by Andrea Giavatto on 11/16/13.
//
//

import Foundation

class Game: NSObject {
    
    let type: SupportedGames
    let launchArguments: String
    var name: String {
        return type.name
    }
    var masterServersList: [String] {
        return type.masterServersList
    }
    
    init(type: SupportedGames, launchArguments: String) {
        self.type = type
        self.launchArguments = launchArguments
    }
    
    override var description: String {
        return "<Game: \(self)> Name: \(type.name)"
    }
}
