//
//  ServerController.swift
//  SQL
//
//  Created by Andrea on 04/07/2018.
//

import Foundation

protocol ServerControllerDelegate: class {
    
    func serverController(_ controller: ServerController, didFinishWithError error: Error?)
    func serverController(_ controller: ServerController, didFinishFetchingServerInfoWith operation: QueryOperation)
    func serverController(_ controller: ServerController, didFinishFetchingServerStatusWith operation: QueryOperation)
    func serverController(_ controller: ServerController, didTimeoutFetchingServerInfoWith operation: QueryOperation)
    func serverController(_ controller: ServerController, didStartFetchingServersInfo: [Server])
    func serverController(_ controller: ServerController, didFinishFetchingServersInfo: [Server])
}

extension ServerControllerDelegate {
    func serverController(_ controller: ServerController, didStartFetchingServersInfo: [Server]) {}
    func serverController(_ controller: ServerController, didFinishFetchingServersInfo: [Server]) {}
}

protocol ServerController {
    
    var delegate: ServerControllerDelegate? { get set }
}
