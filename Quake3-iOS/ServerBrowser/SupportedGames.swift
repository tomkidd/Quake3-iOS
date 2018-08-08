//
//  SupportedGames.swift
//  SQL
//
//  Created by Andrea on 08/06/2018.
//

import Foundation

public enum SupportedGames {
    
    case quake3
    case ut2k4
    
    public var name: String {
        switch self {
        case .quake3:
            return "Quake 3 Arena"
        case .ut2k4:
            return "Unreal Tournament 2004"
        }
    }
    
    public var masterServersList: [String] {
        switch self {
        case .quake3:
            return ["master.ioquake3.org:27950", "master3.idsoftware.com:27950", "master0.excessiveplus.net:27950", "master.maverickservers.com:27950", "dpmaster.deathmask.net:27950"]
        case .ut2k4:
            return ["master0.gamespy.com:27900", "master.qtracker.com:27900", "master.thenerdnetwork.com:27900"] 
        }
    }
    
    public var coordinator: Coordinator {
        switch self {
        case .quake3:
            return Q3Coordinator()
        case .ut2k4:
            return GSCoordinator()
        }
    }
}
