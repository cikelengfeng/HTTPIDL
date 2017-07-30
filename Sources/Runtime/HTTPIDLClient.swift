//
//  BaseClient.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31//

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

fileprivate extension HTTPRequest {
    mutating func update(configuration: RequestConfiguration) {
        if let cp = configuration.cachePolicy {
            cachePolicy = convert(cachePolicy: cp)
        }
        if let tmp = configuration.timeoutInterval {
            timeoutInterval = tmp
        }
        if let nst = configuration.networkServiceType {
            networkServiceType = convert(networkServiceType: nst)
        }
        if let tmp = configuration.shouldUsePipelining {
            shouldUsePipelining = tmp
        }
        if let tmp = configuration.shouldHandleCookies {
            shouldHandleCookies = tmp
        }
        if let tmp = configuration.allowsCellularAccess {
            allowsCellularAccess = tmp
        }
    }
}

public class BaseClient: Client {
    
    public static let shared = BaseClient()
    public var clientImpl: HTTPClient = NSClient.shared
    public var configuration: ClientConfiguration {
        get {
            guard let config = _configuration else {
                return BaseClientConfiguration.shared
            }
            return config
        }
        set {
            _configuration = newValue
        }
    }
    private var _configuration: ClientConfiguration?
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
    
    private func receive(error: HIError, request: Request) {
        responseObserverQueue.async {
            self.responseObservers.forEach { (observer) in
                observer.receive(error: error, request: request)
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
        
        guard requestRewriters.count != 0 else {
            return nil
        }
        
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
        
        guard responseRewriters.count != 0 else {
            return nil
        }
        
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
    
    private func handle<ResponseType : Response>(response: HTTPResponse, responseDecoder: HTTPResponseDecoder, future: RequestFuture<ResponseType>) {
        var resp = response
        if let responseRewriteResult = self.rewrite(response: response) {
            switch responseRewriteResult {
            case .response(let rewritedResponse):
                resp = rewritedResponse
            case .error(let error):
                self.handle(error: error, future: future)
                return
            }
        }
        self.receive(rawResponse: resp)
        self.willDecode(rawResponse: resp)
        do {
            let content = try responseDecoder.decode(resp)
            let httpIdlResponse = try ResponseType(content: content, rawResponse: resp)
            self.didDecode(rawResponse: resp, decodedResponse: httpIdlResponse)
            future.notify(response: httpIdlResponse)
        } catch let error as HIError {
            self.handle(error: error, future: future)
        } catch let error {
            assert(false, "抓到非 HIError 类型的错误！！！")
            self.handle(error: BaseClientError.unknownError(rawError: error), future: future)
        }
    }
    
    private func handle(response: HTTPResponse, future: RequestFuture<HTTPResponse>) {
        var resp = response
        if let responseRewriteResult = self.rewrite(response: response) {
            switch responseRewriteResult {
            case .response(let rewritedResponse):
                resp = rewritedResponse
            case .error(let error):
                self.handle(error: error, future: future)
                return
            }
        }
        future.notify(response: resp)
        self.receive(rawResponse: resp)
    }
    
    private func handle<T>(error: HIError, future: RequestFuture<T>) {
        future.notify(error: error)
        self.receive(error: error, request: future.request)
    }
    
    public func send<ResponseType : Response>(_ request: Request) -> RequestFuture<ResponseType> {
        let future = RequestFuture<ResponseType>(request: request)
        do {
            self.willSend(request: request)
            self.willEncode(request: request)
            let requestEncoder = request.configuration.encoder
            let responseDecoder = request.configuration.decoder
            var encodedRequest = try requestEncoder.encode(request)
            self.didEncode(request: request, encoded: encodedRequest)
            if let rewriterResult = self.rewrite(request: encodedRequest) {
                switch rewriterResult {
                case .request(let rewritedRequest):
                    encodedRequest = rewritedRequest
                case .response(let response):
                    self.handle(response: response, responseDecoder: responseDecoder, future: future)
                    //rewriter已经将request重写成response了，不需要再发请求了
                    return future
                case .error(let error):
                    self.handle(error: error, future: future)
                    //rewriter已经将request重写成error了，不需要再发请求了
                    return future
                }
            }
            encodedRequest.update(configuration: request.configuration)
            let outputSteam = request.configuration.decoder.outputStream
            let futureImpl = clientImpl.send(encodedRequest, usingOutput: outputSteam)
            future.futureImpl = futureImpl
            futureImpl.progressHandler = { p in
                guard let handler = future.progressHandler else {
                    return
                }
                handler(p)
            }
            futureImpl.responseHandler = { (resp) in
                self.handle(response: resp, responseDecoder: responseDecoder, future: future)
            }
            futureImpl.errorHandler = { (error) in
                self.handle(error: error, future: future)
            }
            self.didSend(request: request)
        } catch let error as HIError {
            self.handle(error: error, future: future)
        } catch let error {
            assert(false, "抓到非 HIError 类型的错误！！！")
            self.handle(error: BaseClientError.unknownError(rawError: error), future: future)
        }
        return future
    }
    
    public func send(_ request: Request) -> RequestFuture<HTTPResponse> {
        let future = RequestFuture<HTTPResponse>(request: request)
        do {
            self.willSend(request: request)
            self.willEncode(request: request)
            let requestEncoder = request.configuration.encoder
            var encodedRequest = try requestEncoder.encode(request)
            self.didEncode(request: request, encoded: encodedRequest)
            
            if let rewriterResult = self.rewrite(request: encodedRequest) {
                switch rewriterResult {
                case .request(let rewritedRequest):
                    encodedRequest = rewritedRequest
                case .response(let response):
                    self.handle(response: response, future: future)
                    //rewriter已经将request重写成response了，不需要再发请求了
                    return future
                case .error(let error):
                    self.handle(error: error, future: future)
                    //rewriter已经将request重写成error了，不需要再发请求了
                    return future
                }
            }
            encodedRequest.update(configuration: request.configuration)
            let outputSteam = OutputStream(toMemory: ())
            let futureImpl = clientImpl.send(encodedRequest, usingOutput: outputSteam)
            future.futureImpl = futureImpl
            futureImpl.progressHandler = { p in
                guard let handler = future.progressHandler else {
                    return
                }
                handler(p)
            }
            futureImpl.responseHandler = { (resp) in
                self.handle(response: resp, future: future)
            }
            futureImpl.errorHandler = { (error) in
                self.handle(error: error, future: future)
            }
            self.didSend(request: request)
        } catch let error as HIError {
            self.handle(error: error, future: future)
        } catch let error {
            assert(false, "抓到非 HIError 类型的错误！！！")
            self.handle(error: BaseClientError.unknownError(rawError: error), future: future)
        }
        return future
    }
}
