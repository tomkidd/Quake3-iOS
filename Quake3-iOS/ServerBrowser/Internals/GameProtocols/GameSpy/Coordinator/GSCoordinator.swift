//
//  GSCoordinator.swift
//  SQL
//
//  Created by Andrea on 20/06/2018.
//

import Foundation

class GSCoordinator: NSObject, Coordinator {
    
    var delegate: CoordinatorDelegate?
    
    fileprivate let serverController = GSServerController()
    private var serversList = [Server]()
    private var toRequestInfo = [Server]()
    private let masterServerController = GSMasterServerController()
    private let serverOperationsQueue = DispatchQueue(label: "com.q3browser.gs-server-operations.queue")
    
    func getServersList(host: String, port: String) {
        
    }
    
    func fetchServersInfo() {
        
    }
    
    func info(forServer server: Server) {
        
    }
    
    func status(forServer server: Server) {
        
    }
    
    
}
