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
    let queue: DispatchQueue
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
    
    init(request: HTTPRequest, queue: DispatchQueue) {
        self.request = request
        self.queue = queue
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
        queue.async {
            self.progressHandler?(progress)
        }
    }
    
    func notify(response: HTTPResponse) {
        queue.async {
            self.responseHandler?(response)
        }
    }
    
    func notify(error: HIError) {
        queue.async {
            self.errorHandler?(error)
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}

class NSClient: HTTPClient {
    
    let queue = DispatchQueue(label: "org.httpidl.nsclient.default-callback")
    
    func send(_ request: HTTPRequest) -> HTTPRequestFuture {
        let future = NSRequestFuture(request: request, queue: queue)
        do {
            let dataRequest: URLRequest = try adapt(request)
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
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
            future.notify(error: NSClientError.adaptURLRequestFailed(rawError: err))
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
        return urlRequest
    }
    
    func adapt(data: Data?, response: HTTPURLResponse, request: HTTPRequest) -> HTTPResponse {
        return HTTPBaseResponse(with: response.statusCode, headers: (response.allHeaderFields as? [String: String]) ?? [:], body: data, request: request)
    }
}

