//
//  Coordinator.swift
//  SQL
//
//  Created by Andrea on 08/06/2018.
//

import Foundation

public protocol CoordinatorDelegate: NSObjectProtocol {
    
    func didStartFetchingServersList(for coordinator: Coordinator)
    func didFinishFetchingServersList(for coordinator: Coordinator)
    func didFinishFetchingServersInfo(for coordinator: Coordinator)
    func coordinator(_ coordinator: Coordinator, didFinishFetchingInfoFor server: Server)
    func coordinator(_ coordinator: Coordinator, didFinishFetchingStatusFor server: Server)
    func coordinator(_ coordinator: Coordinator, didFailWith error: SQLError)
}

public protocol Coordinator {
    
    var delegate: CoordinatorDelegate? { get set }
    
    func getServersList(host: String, port: String)
    func fetchServersInfo()
    func info(forServer server: Server)
    func status(forServer server: Server)
}
