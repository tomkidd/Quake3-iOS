//
//  Q3ServerController.swift
//  ServerQueryLibrary
//
//  Created by Andrea Giavatto on 3/16/14.
//
//

import Foundation
import CocoaAsyncSocket

class Q3ServerController: NSObject, ServerController {
    
    weak var delegate: ServerControllerDelegate?

    private let serverInfoQueue = OperationQueue()
    private let statusInfoQueue = OperationQueue()
    
    override init() {
        super.init()
        serverInfoQueue.maxConcurrentOperationCount = 1
    }
  
    func requestServersInfo(_ servers: [Server]) {
        for server in servers {
            infoForServer(ip: server.ip, port: server.port)
        }
        delegate?.serverController(self, didStartFetchingServersInfo: servers)
        serverInfoQueue.addOperation { [unowned self] in
            self.delegate?.serverController(self, didFinishFetchingServersInfo: servers)
        }
    }
    
    func infoForServer(ip: String, port: String) {
        
        guard let port = UInt16(port) else {
            return
        }
        
        let infoResponseMarker: [UInt8] = [0xff, 0xff, 0xff, 0xff, 0x69, 0x6e, 0x66, 0x6f, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x0a, 0x5c] // YYYYinfoResponse\n\
        let infoRequestMarker: [UInt8] = [0xff, 0xff, 0xff, 0xff, 0x67, 0x65, 0x74, 0x69, 0x6e, 0x66, 0x6f, 0x0a]
        let infoOperation = Q3Operation(ip: ip, port: port, requestMarker: infoRequestMarker, responseMarker: infoResponseMarker)

        infoOperation.completionBlock = { [unowned self, weak infoOperation] in
            
            guard let infoOperation = infoOperation else {
                return
            }
            
            if infoOperation.isCancelled {
                return
            }
            
            if infoOperation.timeoutOccurred {
                self.delegate?.serverController(self, didTimeoutFetchingServerInfoWith: infoOperation)
            } else if infoOperation.error != nil {
                self.delegate?.serverController(self, didFinishWithError: infoOperation.error)
            } else {
                self.delegate?.serverController(self, didFinishFetchingServerInfoWith: infoOperation)
            }
        }
        serverInfoQueue.addOperation(infoOperation)
    }

    func statusForServer(ip: String, port: String) {
        
        guard let port = UInt16(port) else {
            return
        }
        
        let statusRequestMarker: [UInt8] = [0xff, 0xff, 0xff, 0xff, 0x67, 0x65, 0x74, 0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x0a]
        let statusResponseMarker: [UInt8] = [0xff, 0xff, 0xff, 0xff, 0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x0a, 0x5c] // YYYYstatusResponse\n\
        let statusOperation = Q3Operation(ip: ip, port: port, requestMarker: statusRequestMarker, responseMarker: statusResponseMarker)
        
        statusOperation.completionBlock = { [unowned self, weak statusOperation] in
            
            guard let statusOperation = statusOperation else {
                return
            }
            
            if statusOperation.isCancelled {
                return
            }
            
            if let error = statusOperation.error {
                self.delegate?.serverController(self, didFinishWithError: error)
            } else {
                self.delegate?.serverController(self, didFinishFetchingServerStatusWith: statusOperation)
            }
        }
        
        statusInfoQueue.addOperation(statusOperation)
    }
    
    func clearPendingRequests() {
        serverInfoQueue.cancelAllOperations()
        statusInfoQueue.cancelAllOperations()
    }
}
