//
//  Q3Operation.swift
//  ServerQueryLibrary
//
//  Created by Andrea on 24/10/2017.
//

import Foundation
import CocoaAsyncSocket

let socketDelegateQueue = DispatchQueue.main

class Q3Operation: Operation, QueryOperation {
    
    let ip: String
    let port: UInt16
    let requestMarker: [UInt8]
    let responseMarker: [UInt8]
    
    fileprivate(set) var data = Data()
    fileprivate(set) var executionTime: TimeInterval = 0.0
    fileprivate(set) var error: Error?
    fileprivate var startTime: TimeInterval?
    private var socket: GCDAsyncUdpSocket?
    private var timer: Timer?
    fileprivate(set) var timeoutOccurred = false
    private let timeout: TimeInterval = 1.0
    
    required init(ip: String, port: UInt16, requestMarker: [UInt8], responseMarker: [UInt8]) {
        self.ip = ip
        self.port = port
        self.requestMarker = requestMarker
        self.responseMarker = responseMarker
        
        super.init()
        
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: socketDelegateQueue)
        socket?.setMaxReceiveIPv4BufferSize(8192)
        socket?.setMaxReceiveIPv6BufferSize(8192)
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    override func start() {
        
        guard isCancelled == false else {
            finish()
            return
        }
        
        self._executing = true
        
        let data = Data(self.requestMarker)
        do {
            self.socket?.send(data, toHost: self.ip, port: self.port, withTimeout: timeout, tag: 42)
            try self.socket?.receiveOnce()
        } catch(_) {
            self.finish()
        }
    }
    
    func finish() {
        _executing = false
        _finished = true
        socket?.close()
        socket = nil
    }
    
    @objc func didNotReceiveResponseInTime(_ sender: Timer) {
        timer?.invalidate()
        timer = nil
        timeoutOccurred = true
        finish()
    }
}

extension Q3Operation {
    
    public override var description: String {
        
        return super.description + " \(ip):\(port)"
    }
}

extension Q3Operation: GCDAsyncUdpSocketDelegate {
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        startTime = CFAbsoluteTimeGetCurrent()
        timer = Timer.scheduledTimer(timeInterval: timeout, target: self, selector: #selector(didNotReceiveResponseInTime), userInfo: nil, repeats: false)
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        timer?.invalidate()
        timer = nil
        let endTime = CFAbsoluteTimeGetCurrent()
        self.data.append(data)
        
        let prefix = String(bytes: responseMarker, encoding: .ascii)
        let asciiRep = String(data: self.data, encoding: .ascii)
        
        if
            let asciiRep = asciiRep,
            let prefix = prefix,
            asciiRep.hasPrefix(prefix),
            let startTime = startTime
        {
            let start = self.data.index(self.data.startIndex, offsetBy: responseMarker.count)
            let end = self.data.endIndex
            self.data = self.data.subdata(in: start..<end)
            executionTime = endTime - startTime
        }
        finish()
    }
    
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        timer?.invalidate()
        timer = nil
        self.error = error
        if !_finished {
            finish()
        }
    }
}
