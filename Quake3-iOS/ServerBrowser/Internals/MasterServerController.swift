//
//  MasterServerController.swift
//  SQL
//
//  Created by Andrea on 04/07/2018.
//

import Foundation

protocol MasterServerControllerDelegate: class {
    
    func didStartFetchingServers(forMasterController controller: MasterServerController)
    func masterController(_ controller: MasterServerController, didFinishWithError error: Error?)
    func masterController(_ controller: MasterServerController, didFinishFetchingServersWith data: Data)
}

extension MasterServerControllerDelegate {
    
    func didStartFetchingServers(forMasterController controller: MasterServerController) {}
}

protocol MasterServerController {
    
    var delegate: MasterServerControllerDelegate? { get set }
    func startFetchingServersList(host: String, port: String)
}
