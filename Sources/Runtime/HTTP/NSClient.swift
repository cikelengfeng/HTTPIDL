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

class NSRequestFuture: HTTPRequestFuture {
    let request: HTTPRequest
    var task: URLSessionDataTask?
    var progressHandler: ((Progress) -> Void)?
    var responseHandler: ((HTTPResponse) -> Void)?
    var errorHandler: ((HIError) -> Void)?
    
    func notify(progress: Progress) {
        progressHandler?(progress)
    }
    
    func notify(response: HTTPResponse) {
        responseHandler?(response)
    }
    
    func notify(error: HIError) {
        errorHandler?(error)
    }
    
    init(request: HTTPRequest) {
        self.request = request
    }
    
    func cancel() {
        task?.cancel()
    }
}

class NSClient: HTTPClient {
    
    let queue = DispatchQueue(label: "org.httpidl.nsclient.default-callback")
    
    func send(_ request: HTTPRequest) -> HTTPRequestFuture {
        var future = NSRequestFuture(request: request)
        do {
            let dataRequest: URLRequest = try adapt(request)
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: dataRequest, completionHandler: { (data, response, error) in
                if let err = error {
                    self.queue.async {
                        future.notify(error: NSClientError.adaptURLResponseFailed(rawError: err))
                    }
                    return
                }
                guard let resp = response as? HTTPURLResponse else {
                    self.queue.async {
                        future.notify(error: NSClientError.missingResponse(request: request))
                    }
                    return
                }
                let result = self.adapt(data: data, response: resp, request: request)
                self.queue.async {
                    future.notify(response: result)
                }
            })
            future.task = task
            task.resume()
        } catch let err {
            self.queue.async {
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
        return urlRequest
    }
    
    func adapt(data: Data?, response: HTTPURLResponse, request: HTTPRequest) -> HTTPResponse {
        return HTTPBaseResponse(with: response.statusCode, headers: (response.allHeaderFields as? [String: String]) ?? [:], body: nil, request: request)
    }
}

