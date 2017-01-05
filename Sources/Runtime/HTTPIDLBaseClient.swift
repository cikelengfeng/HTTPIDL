//
//  HTTPIDLBaseClient.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

public enum HTTPIDLBaseClientError: Error {
    case noResponse
}

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
    
    public func send<ResponseType : HTTPIDLResponse>(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (ResponseType) -> Void, errorHandler: ((Error) -> Void)?) {
        do {
            self.willSend(request: request)
            self.willEncode(request: request)
            let encodedRequest = try requestEncoder.encode(request)
            self.didEncode(request: request, encoded: encodedRequest)
            clientImpl.send(encodedRequest, completion: { (response) in
                do {
                    self.receive(rawResponse: response)
                    self.willDecode(rawResponse: response)
                    let httpIdlResponse = try ResponseType(httpResponse: response)
                    completion(httpIdlResponse)
                    self.didDecode(rawResponse: response, decodedResponse: httpIdlResponse)
                } catch let error {
                    errorHandler?(error)
                    self.receive(error: error)
                }
            }, errorHandler: { (error) in
                errorHandler?(error)
                self.receive(error: error)
            })
            self.didSend(request: request)
        } catch let error {
            errorHandler?(error)
            self.receive(error: error)
        }
    }
    
    public func send(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (HTTPResponse) -> Void, errorHandler: ((Error) -> Void)?) {
        do {
            self.willSend(request: request)
            self.willEncode(request: request)
            let encodedRequest = try requestEncoder.encode(request)
            self.didEncode(request: request, encoded: encodedRequest)
            clientImpl.send(encodedRequest, completion: { (response) in
                completion(response)
                self.receive(rawResponse: response)
            }, errorHandler: { (error) in
                errorHandler?(error)
                self.receive(error: error)
            })
            self.didSend(request: request)
        } catch let error {
            errorHandler?(error)
            self.receive(error: error)
        }
    }
}
