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
    case writeToStreamFailed(rawError: Error)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .missingResponse(let request):
                return "HTTPURLResponse为空, request: \(request)"
            case .adaptURLRequestFailed(let error):
                return "生成URLRequest出错, 原始错误: \(error)"
            case .adaptURLResponseFailed(let error):
                return "请求出错, 原始错误: \(error)"
            case .writeToStreamFailed(let error):
                return "写response数据出错, 原始错误: \(error)"
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

fileprivate class TaskManager: NSObject, URLSessionDataDelegate {
    let fallthroughDelegate: URLSessionDataDelegate?
    var taskMap: [Int: (future: HTTPRequestFuture, resp: HTTPResponse)]
    
    init(fallthroughDelegate: URLSessionDataDelegate?) {
        self.fallthroughDelegate = fallthroughDelegate
        self.taskMap = [Int: (future: HTTPRequestFuture, resp: HTTPResponse)]()
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let fr = self.taskMap[dataTask.taskIdentifier] else {
            assert(false, "request future is nil, it's impossible!!!")
            completionHandler(.cancel)
            return
        }
        let future = fr.future
        guard let httpResp = response as? HTTPURLResponse else {
            future.notify(error: NSClientError.missingResponse(request: future.request))
            completionHandler(.cancel)
            return
        }
        let resp = fr.resp
        let newResp = HTTPBaseResponse(with: httpResp.statusCode, headers: httpResp.allHeaderFields as? [String: String] ?? [:], bodyStream: resp.bodyStream, request: resp.request)
        self.taskMap[dataTask.taskIdentifier] = (future, newResp)
        newResp.bodyStream?.open()
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let fr = self.taskMap[dataTask.taskIdentifier] else {
            return
        }
        guard let output = fr.resp.bodyStream else {
            return
        }
        do {
            try data.writeTo(stream: output)
        } catch let error {
            let future = fr.future
            future.notify(error: NSClientError.writeToStreamFailed(rawError: error))
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let fr = self.taskMap[task.taskIdentifier] else {
            return
        }
        let future = fr.future
        let resp = fr.resp
        if let err = error {
            future.notify(error: NSClientError.adaptURLResponseFailed(rawError: err))
            resp.bodyStream?.close()
            return
        }
        resp.bodyStream?.close()
        future.notify(response: resp)
        self.taskMap.removeValue(forKey: task.taskIdentifier)
    }
}

public class NSClient: NSObject, HTTPClient, URLSessionDataDelegate {
    
    public static let shared = { _ -> NSClient in
        let configuration = URLSessionConfiguration.default
        let queue = OperationQueue()
        queue.name = "org.httpidl.nsclient.default-callback"
        let client = NSClient(configuration: configuration, delegate: nil, delegateQueue: queue)
        return client
    }()
    
    public let session: URLSession
    private let taskManager: TaskManager
    
    public init(configuration: URLSessionConfiguration, delegate: URLSessionDataDelegate?, delegateQueue: OperationQueue?) {
        self.taskManager = TaskManager(fallthroughDelegate: delegate)
        self.session = URLSession(configuration: configuration, delegate: self.taskManager, delegateQueue: delegateQueue)
    }
    
    public func send(_ request: HTTPRequest, usingOutput outputStream: OutputStream?) -> HTTPRequestFuture {
        let future = NSRequestFuture(request: request)
        do {
            let dataRequest: URLRequest = try adapt(request)
            
            let task = session.dataTask(with: dataRequest)
            
            future.task = task
            self.taskManager.taskMap[task.taskIdentifier] = (future, HTTPBaseResponse(with: 0, headers: [:], bodyStream: outputStream, request: request))
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
        urlRequest.httpBodyStream = request.bodyStream
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
    
}

