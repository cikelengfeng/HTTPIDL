//
//  HTTPIDLBaseClient.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

public class HTTPIDLBaseClient: HTTPIDLClient {
    
    public static let shared = HTTPIDLBaseClient()
    private var clientImpl: HTTPClient = AlamofireClient()
    private var requestObservers: [HTTPRequestObserver] = []
    private var responseObservers: [HTTPResponseObserver] = []
    private let requestObserverLock = NSLock()
    private let responseObserverLock = NSLock()
    
    public func add(requestObserver: HTTPRequestObserver) {
        requestObserverLock.lock()
        requestObservers.append(requestObserver)
        requestObserverLock.unlock()
    }
    
    public func remove(requestObserver: HTTPRequestObserver) {
        requestObserverLock.lock()
        if let index = requestObservers.index(where: { (observer) -> Bool in
            return observer === requestObserver
        }) {
            requestObservers.remove(at: index)
        }
        requestObserverLock.unlock()
    }
    
    public func add(responseObserver: HTTPResponseObserver) {
        responseObserverLock.lock()
        responseObservers.append(responseObserver)
        responseObserverLock.unlock()
    }
    
    public func remove(responseObserver: HTTPResponseObserver) {
        responseObserverLock.lock()
        if let index = responseObservers.index(where: { (observer) -> Bool in
            return observer === responseObserver
        }) {
            responseObservers.remove(at: index)
        }
        responseObserverLock.unlock()
    }
    
    private func willSend(request: HTTPIDLRequest) {
        requestObservers.forEach { (observer) in
            observer.willSend(request: request)
        }
    }
    private func didSend(request: HTTPIDLRequest) {
        requestObservers.forEach { (observer) in
            observer.didSend(request: request)
        }
    }
    private func willEncode(request: HTTPIDLRequest) {
        requestObservers.forEach { (observer) in
            observer.willEncode(request: request)
        }
    }
    private func didEncode(request: HTTPIDLRequest, encoded: HTTPRequest) {
        requestObservers.forEach { (observer) in
            observer.didEncode(request: request, encoded: encoded)
        }
    }
    
    private func receive(error: Error) {
        responseObservers.forEach { (observer) in
            observer.receive(error: error)
        }
    }
    
    private func receive(rawResponse: HTTPResponse) {
        responseObservers.forEach { (observer) in
            observer.receive(rawResponse: rawResponse)
        }
    }
    
    private func willDecode(rawResponse: HTTPResponse) {
        responseObservers.forEach { (observer) in
            observer.willDecode(rawResponse: rawResponse)
        }
    }
    private func didDecode(rawResponse: HTTPResponse, decodedResponse: HTTPIDLResponse) {
        responseObservers.forEach { (observer) in
            observer.didDecode(rawResponse: rawResponse, decodedResponse: decodedResponse)
        }
    }
    
    public func send<ResponseType : HTTPIDLResponse>(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (ResponseType?, Error?) -> Void) {
        do {
            self.willSend(request: request)
            self.willEncode(request: request)
            let encodedRequest = try requestEncoder.encode(request)
            self.didEncode(request: request, encoded: encodedRequest)
            clientImpl.send(encodedRequest) { (clientResponse, clientError) in
                do {
                    guard let clientResponse = clientResponse else {
                        completion(nil, clientError)
                        if let err = clientError {
                            self.receive(error: err)
                        }
                        return
                    }
                    self.receive(rawResponse: clientResponse)
                    self.willDecode(rawResponse: clientResponse)
                    let httpIdlResponse = try ResponseType(httpResponse: clientResponse)
                    completion(httpIdlResponse, clientError)
                    self.didDecode(rawResponse: clientResponse, decodedResponse: httpIdlResponse)
                } catch let error {
                    completion(nil, error)
                    self.receive(error: error)
                }
            }
            self.didSend(request: request)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func send(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (HTTPResponse?, Error?) -> Void) {
        do {
            self.willSend(request: request)
            self.willEncode(request: request)
            let encodedRequest = try requestEncoder.encode(request)
            self.didEncode(request: request, encoded: encodedRequest)
            clientImpl.send(encodedRequest) { (clientResponse, clientError) in
                guard let clientResponse = clientResponse else {
                    completion(nil, clientError)
                    if let err = clientError {
                        self.receive(error: err)
                    }
                    return
                }
                completion(clientResponse, clientError)
                self.receive(rawResponse: clientResponse)
            }
            self.didSend(request: request)
        } catch let error {
            completion(nil, error)
            self.receive(error: error)
        }
    }
}
