//
//  BaseClient.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

public enum BaseClientError: HIError {
    case unknownError(rawError: Error)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .unknownError(let error):
                return "未知错误，通常是某个各组件抛出了非HIError类型的错误导致的, 原是错误: \(error)"
            }
        }
    }
}

public class BaseClient: Client {
    
    public static let shared = BaseClient()
    private var clientImpl: HTTPClient = AlamofireClient()
    private var requestObservers: [HTTPRequestObserver] = []
    private var responseObservers: [HTTPResponseObserver] = []
    private var requestRewriters: [HTTPRequestRewriter] = []
    private var responseRewriters: [HTTPResponseRewriter] = []
    
    private let requestObserverQueue: DispatchQueue = DispatchQueue(label: "httpidl.requestObserver")
    private let responseObserverQueue: DispatchQueue = DispatchQueue(label: "httpidl.responseObserver")
    private let requestRewriterQueue: DispatchQueue = DispatchQueue(label: "httpidl.requestRewriter")
    private let responseRewriterQueue: DispatchQueue = DispatchQueue(label: "httpidl.responseRewriter")
    
    public func add(requestObserver: HTTPRequestObserver) {
        requestObserverQueue.sync {
            requestObservers.append(requestObserver)
        }
    }
    
    public func remove(requestObserver: HTTPRequestObserver) {
        requestObserverQueue.sync {
            if let index = requestObservers.index(where: { (observer) -> Bool in
                return observer === requestObserver
            }) {
                requestObservers.remove(at: index)
            }
        }
    }
    
    public func add(responseObserver: HTTPResponseObserver) {
        responseObserverQueue.sync {
            responseObservers.append(responseObserver)
        }
    }
    
    public func remove(responseObserver: HTTPResponseObserver) {
        responseObserverQueue.sync {
            if let index = responseObservers.index(where: { (observer) -> Bool in
                return observer === responseObserver
            }) {
                responseObservers.remove(at: index)
            }
        }
    }
    
    public func add(requestRewriter: HTTPRequestRewriter) {
        requestRewriterQueue.sync {
            self.requestRewriters.append(requestRewriter)
        }
    }
    
    public func remove(requestRewriter: HTTPRequestRewriter) {
        requestRewriterQueue.sync {
            if let index = requestRewriters.index(where: { (rewriter) -> Bool in
                return rewriter === requestRewriter
            }) {
                requestRewriters.remove(at: index)
            }
        }
    }
    
    public func add(responseRewriter: HTTPResponseRewriter) {
        responseRewriterQueue.sync {
            self.responseRewriters.append(responseRewriter)
        }
    }
    
    public func remove(responseRewriter: HTTPResponseRewriter) {
        responseRewriterQueue.sync {
            if let index = responseRewriters.index(where: { (rewriter) -> Bool in
                return rewriter === responseRewriter
            }) {
                responseRewriters.remove(at: index)
            }
        }
    }

    
    private func willSend(request: Request) {
        requestObserverQueue.async {
            self.requestObservers.forEach { (observer) in
                observer.willSend(request: request)
            }
        }
    }
    private func didSend(request: Request) {
        requestObserverQueue.async {
            self.requestObservers.forEach { (observer) in
                observer.didSend(request: request)
            }
        }
    }
    private func willEncode(request: Request) {
        requestObserverQueue.async {
            self.requestObservers.forEach { (observer) in
                observer.willEncode(request: request)
            }
        }
    }
    private func didEncode(request: Request, encoded: HTTPRequest) {
        requestObserverQueue.async {
            self.requestObservers.forEach { (observer) in
                observer.didEncode(request: request, encoded: encoded)
            }
        }
    }
    
    private func receive(error: HIError) {
        responseObserverQueue.async {
            self.responseObservers.forEach { (observer) in
                observer.receive(error: error)
            }
        }
    }
    
    private func receive(rawResponse: HTTPResponse) {
        responseObserverQueue.async {
            self.responseObservers.forEach { (observer) in
                observer.receive(rawResponse: rawResponse)
            }
        }
    }
    
    private func willDecode(rawResponse: HTTPResponse) {
        responseObserverQueue.async {
            self.responseObservers.forEach { (observer) in
                observer.willDecode(rawResponse: rawResponse)
            }
        }
    }
    private func didDecode(rawResponse: HTTPResponse, decodedResponse: Response) {
        responseObserverQueue.async {
            self.responseObservers.forEach { (observer) in
                observer.didDecode(rawResponse: rawResponse, decodedResponse: decodedResponse)
            }
        }
    }
    
    private func rewrite(request: HTTPRequest) -> HTTPRequestRewriterResult? {
        var ret: HTTPRequestRewriterResult = HTTPRequestRewriterResult.request(request: request)
        requestRewriterQueue.sync {
            var req = request
            for rewriter in requestRewriters {
                let rewriterResult = rewriter.rewrite(request: req)
                ret = rewriterResult
                switch rewriterResult {
                    //如果任何一个结果被重写成了response或error都结束循环，直接返回最后的rewrite结果
                    //如果重写后还是一个request，则将重写后的request交给下一个rewriter重写，如果后面没有rewriter了，就将这次重写的结果返回
                    case .request(let rewritedRequest):
                        req = rewritedRequest
                    case .response(_), .error(_):
                        break
                }
            }
        }
        return ret
    }
    
    private func rewrite(response: HTTPResponse) -> HTTPResponseRewriterResult? {
        var ret: HTTPResponseRewriterResult = HTTPResponseRewriterResult.response(response: response)
        requestRewriterQueue.sync {
            var resp = response
            for rewriter in responseRewriters {
                let rewriterResult = rewriter.rewrite(response: resp)
                ret = rewriterResult
                switch rewriterResult {
                    //如果任何一个结果被重写成了error都结束循环，直接返回最后的rewrite结果
                    //如果重写后还是一个response，则将重写后的response交给下一个rewriter重写，如果后面没有rewriter了，就将这次重写的结果返回
                case .response(let rewritedResponse):
                    resp = rewritedResponse
                case .error(_):
                    break
                }
            }
        }
        return ret
    }
    
    private func handle<ResponseType : Response>(response: HTTPResponse, responseDecoder: HTTPResponseDecoder, completion: @escaping (ResponseType) -> Void, errorHandler: ((HIError) -> Void)?) {
        var resp = response
        if let responseRewriteResult = self.rewrite(response: response) {
            switch responseRewriteResult {
            case .response(let rewritedResponse):
                resp = rewritedResponse
            case .error(let error):
                self.handle(error: error, errorHandler: errorHandler)
                return
            }
        }
        self.receive(rawResponse: resp)
        self.willDecode(rawResponse: resp)
        do {
            let parameters = try responseDecoder.decode(resp)
            let httpIdlResponse = try ResponseType(parameters: parameters, rawResponse: resp)
            completion(httpIdlResponse)
            self.didDecode(rawResponse: resp, decodedResponse: httpIdlResponse)
        } catch let error as HIError {
            self.handle(error: error, errorHandler: errorHandler)
        } catch let error {
            assert(false, "抓到非 HIError 类型的错误！！！")
            self.handle(error: BaseClientError.unknownError(rawError: error), errorHandler: errorHandler)
        }
    }
    
    private func handle(response: HTTPResponse, completion: @escaping (HTTPResponse) -> Void, errorHandler: ((HIError) -> Void)?) {
        var resp = response
        if let responseRewriteResult = self.rewrite(response: response) {
            switch responseRewriteResult {
            case .response(let rewritedResponse):
                resp = rewritedResponse
            case .error(let error):
                self.handle(error: error, errorHandler: errorHandler)
                return
            }
        }
        completion(resp)
        self.receive(rawResponse: resp)
    }
    
    private func handle(error: HIError, errorHandler: ((HIError) -> Void)?) {
        errorHandler?(error)
        self.receive(error: error)
    }
    
    public func send<ResponseType : Response>(_ request: Request, requestEncoder: HTTPRequestEncoder, responseDecoder: HTTPResponseDecoder, completion: @escaping (ResponseType) -> Void, errorHandler: ((HIError) -> Void)?) {
        do {
            self.willSend(request: request)
            self.willEncode(request: request)
            var encodedRequest = try requestEncoder.encode(request)
            self.didEncode(request: request, encoded: encodedRequest)
            if let rewriterResult = self.rewrite(request: encodedRequest) {
                switch rewriterResult {
                case .request(let rewritedRequest):
                    encodedRequest = rewritedRequest
                case .response(let response):
                    self.handle(response: response, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
                case .error(let error):
                    self.handle(error: error, errorHandler: errorHandler)
                }
            }
            clientImpl.send(encodedRequest, completion: { (response) in
                self.handle(response: response, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
            }, errorHandler: { (error) in
                self.handle(error: error, errorHandler: errorHandler)
            })
            self.didSend(request: request)
        } catch let error as HIError {
            self.handle(error: error, errorHandler: errorHandler)
        } catch let error {
            assert(false, "抓到非 HIError 类型的错误！！！")
            self.handle(error: BaseClientError.unknownError(rawError: error), errorHandler: errorHandler)
        }
    }
    
    public func send(_ request: Request, requestEncoder: HTTPRequestEncoder, completion: @escaping (HTTPResponse) -> Void, errorHandler: ((HIError) -> Void)?) {
        do {
            self.willSend(request: request)
            self.willEncode(request: request)
            var encodedRequest = try requestEncoder.encode(request)
            self.didEncode(request: request, encoded: encodedRequest)
            
            if let rewriterResult = self.rewrite(request: encodedRequest) {
                switch rewriterResult {
                case .request(let rewritedRequest):
                    encodedRequest = rewritedRequest
                case .response(let response):
                    self.handle(response: response, completion: completion, errorHandler: errorHandler)
                case .error(let error):
                    self.handle(error: error, errorHandler: errorHandler)
                }
            }
            clientImpl.send(encodedRequest, completion: { (response) in
                self.handle(response: response, completion: completion, errorHandler: errorHandler)
            }, errorHandler: { (error) in
                self.handle(error: error, errorHandler: errorHandler)
            })
            self.didSend(request: request)
        } catch let error as HIError {
            self.handle(error: error, errorHandler: errorHandler)
        } catch let error {
            assert(false, "抓到非 HIError 类型的错误！！！")
            self.handle(error: BaseClientError.unknownError(rawError: error), errorHandler: errorHandler)
        }
    }
}
