//
//  NSClient.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/29.
//
//

import Foundation

public enum NSClientError: HIError {
    case missingResponse(request: HTTPRequest)
    case adaptURLRequestFailed(rawError: Error)
    case adaptURLResponseFailed(rawError: Error)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .missingResponse(let request):
                return "HTTPURLResponse为空, request: \(request)"
            case .adaptURLRequestFailed(let error):
                return "生成URLRequest出错, 原始错误: \(error)"
            case .adaptURLResponseFailed(let error):
                return "请求出错, 原始错误: \(error)"
            }
        }
    }
}

class NSRequestFuture: NSObject, HTTPRequestFuture {
    let request: HTTPRequest
    var task: URLSessionDataTask? {
        set {
            _task = newValue
        }
        get { return _task }
    }
    var progressHandler: ((Progress) -> Void)?
    var responseHandler: ((HTTPResponse) -> Void)?
    var errorHandler: ((HIError) -> Void)?
    let overallProgress: Progress
    let sendProgress: Progress
    let receiveProgress: Progress
    
    
    private var _task: URLSessionDataTask? {
        willSet {
            _task?.removeObserver(self, forKeyPath: "countOfBytesReceived")
            _task?.removeObserver(self, forKeyPath: "countOfBytesSent")
            _task?.removeObserver(self, forKeyPath: "countOfBytesExpectedToReceive")
            _task?.removeObserver(self, forKeyPath: "countOfBytesExpectedToSend")
        }
        didSet {
            guard let t = _task else {
                return
            }
            t.addObserver(self, forKeyPath: "countOfBytesReceived", options: .new, context: nil)
            t.addObserver(self, forKeyPath: "countOfBytesSent", options: .new, context: nil)
            t.addObserver(self, forKeyPath: "countOfBytesExpectedToReceive", options: .new, context: nil)
            t.addObserver(self, forKeyPath: "countOfBytesExpectedToSend", options: .new, context: nil)
        }
    }
    
    deinit {
        _task?.removeObserver(self, forKeyPath: "countOfBytesReceived")
        _task?.removeObserver(self, forKeyPath: "countOfBytesSent")
        _task?.removeObserver(self, forKeyPath: "countOfBytesExpectedToReceive")
        _task?.removeObserver(self, forKeyPath: "countOfBytesExpectedToSend")
    }
    
    init(request: HTTPRequest) {
        self.request = request
        overallProgress = Progress(totalUnitCount: 2)
        overallProgress.becomeCurrent(withPendingUnitCount: overallProgress.totalUnitCount / 2)
        sendProgress = Progress(totalUnitCount: Int64.max)
        overallProgress.resignCurrent()
        overallProgress.becomeCurrent(withPendingUnitCount: overallProgress.totalUnitCount / 2)
        receiveProgress = Progress(totalUnitCount: Int64.max)
        overallProgress.resignCurrent()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let task = self.task, let keyPath = keyPath else {
            return
        }
        
        switch keyPath {
        case "countOfBytesExpectedToReceive" :
            receiveProgress.totalUnitCount = task.countOfBytesExpectedToReceive
        case "countOfBytesReceived" :
            receiveProgress.completedUnitCount = task.countOfBytesReceived
        case "countOfBytesExpectedToSend" :
            sendProgress.totalUnitCount = task.countOfBytesExpectedToSend
        case "countOfBytesSent" :
            sendProgress.completedUnitCount = task.countOfBytesSent
        default: break
        }
        
        notify(progress: overallProgress)
    }
    
    private func resetProgress() {
        self.overallProgress.completedUnitCount = 0
        self.sendProgress.completedUnitCount = 0
        self.receiveProgress.completedUnitCount = 0
    }
    
    func notify(progress: Progress) {
        self.progressHandler?(progress)
    }
    
    func notify(response: HTTPResponse) {
        self.responseHandler?(response)
    }
    
    func notify(error: HIError) {
        self.errorHandler?(error)
    }
    
    func cancel() {
        task?.cancel()
    }
}

public class NSClient: HTTPClient {
    
    public static let shared = { _ -> NSClient in
        let configuration = URLSessionConfiguration.default
        let queue = OperationQueue()
        queue.name = "org.httpidl.nsclient.default-callback"
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
        return NSClient(session: session)
    }()
    
    public let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func send(_ request: HTTPRequest) -> HTTPRequestFuture {
        let future = NSRequestFuture(request: request)
        do {
            let dataRequest: URLRequest = try adapt(request)
            
            let task = session.dataTask(with: dataRequest, completionHandler: { (data, response, error) in
                if let err = error {
                    future.notify(error: NSClientError.adaptURLResponseFailed(rawError: err))
                    return
                }
                guard let resp = response as? HTTPURLResponse else {
                    future.notify(error: NSClientError.missingResponse(request: request))
                    return
                }
                let result = self.adapt(data: data, response: resp, request: request)
                future.notify(response: result)
            })
            
            future.task = task
            task.resume()
        } catch let err {
            session.delegateQueue.addOperation {
                future.notify(error: NSClientError.adaptURLRequestFailed(rawError: err))
            }
        }
        return future
    }
    
    func adapt(_ request: HTTPRequest) throws -> URLRequest {
        var urlRequest = URLRequest(url: request.url)
        request.headers.forEach { (kv) in
            urlRequest.setValue(kv.value, forHTTPHeaderField: kv.key)
        }
        urlRequest.httpMethod = request.method
        urlRequest.httpBody = try request.body()
        if let cachePolicy = request.cachePolicy {
            urlRequest.cachePolicy = cachePolicy
        }
        if let timeout = request.timeoutInterval {
            urlRequest.timeoutInterval = timeout
        }
        if let shouldPipeline = request.shouldUsePipelining {
            urlRequest.httpShouldUsePipelining = shouldPipeline
        }
        if let shoudHandleCookie = request.shouldHandleCookies {
            urlRequest.httpShouldHandleCookies = shoudHandleCookie
        }
        if let networkService = request.networkServiceType {
            urlRequest.networkServiceType = networkService
        }
        if let allowCellar = request.allowsCellularAccess {
            urlRequest.allowsCellularAccess = allowCellar
        }
        return urlRequest
    }
    
    func adapt(data: Data?, response: HTTPURLResponse, request: HTTPRequest) -> HTTPResponse {
        return HTTPBaseResponse(with: response.statusCode, headers: (response.allHeaderFields as? [String: String]) ?? [:], body: data, request: request)
    }
}

