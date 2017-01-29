//
//  NSClient.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/29.
//
//

import Foundation

enum NSClientError: HIError {
    case missingResponse(request: HTTPRequest)
    case adaptURLRequestFailed(rawError: Error)
    case adaptURLResponseFailed(rawError: Error)
    
    var errorDescription: String? {
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

struct NSClient: HTTPClient {
    
    func send(_ request: HTTPRequest, completion: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        do {
            let dataRequest: URLRequest = try adapt(request)
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: dataRequest, completionHandler: { (data, response, error) in
                if let err = error {
                    errorHandler(NSClientError.adaptURLResponseFailed(rawError: err))
                    return
                }
                guard let resp = response as? HTTPURLResponse else {
                    errorHandler(NSClientError.missingResponse(request: request))
                    return
                }
                let result = self.adapt(data: data, response: resp, request: request)
                completion(result)
            })
            task.resume()
        } catch let err {
            errorHandler(NSClientError.adaptURLRequestFailed(rawError: err))
        }
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

