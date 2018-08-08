//
//  Player.swift
//  ServerQueryLibrary
//
//  Created by Andrea Giavatto on 3/23/14.
//
//

import Foundation

public protocol Player {
    
    var name: String { get }
    var ping: String { get }
    var score: String { get }

    init?(line: String)
}
