//
//  QueryOperation.swift
//  SQL
//
//  Created by Andrea on 04/07/2018.
//

import Foundation

protocol QueryOperation {
    
    var ip: String { get }
    var port: UInt16 { get }
    var requestMarker: [UInt8] { get }
    var responseMarker: [UInt8] { get }
    var data: Data { get }
    var executionTime: TimeInterval { get }
}
