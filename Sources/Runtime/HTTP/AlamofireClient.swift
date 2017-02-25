//
//  HTTPRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28//

import Foundation
import Alamofire

public enum AlamofireClientError: HIError {
    case missingResponse(request: HTTPRequest)
    case adaptAlamofireRequestFailed(rawError: Error)
    case adaptAlamofireResponseFailed(rawError: Error)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .missingResponse(let request):
                return "HTTPURLResponse为空, request: \(request)"
            case .adaptAlamofireRequestFailed(let error):
                return "生成alamofire DataRequest出错, 原始错误: \(error)"
            case .adaptAlamofireResponseFailed(let error):
                return "从alamofire http 请求出错, 原始错误: \(error)"
            }
        }
    }
}

class AlamofireRequestFuture: HTTPRequestFuture {
    let request: HTTPRequest
    var alamofireRequest: DataRequest?
    var progressHandler: ((Progress) -> Void)?
    var responseHandler: ((HTTPResponse) -> Void)?
    var errorHandler: ((HIError) -> Void)?
    
    func cancel() {
        alamofireRequest?.cancel()
    }
    
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
}

class AlamofireClient: HTTPClient {
    
    let queue = DispatchQueue(label: "org.httpidl.alamofire.default-callback")
    
    func send(_ request: HTTPRequest) -> HTTPRequestFuture {
        let future = AlamofireRequestFuture(request: request)
        do {
            let dataRequest: DataRequest = try adapt(request)
            future.alamofireRequest = dataRequest
            dataRequest.responseData(queue: self.queue, completionHandler: { (response) in
                let callbackTuple = self.adapt(response: response, request: request)
                if let error = callbackTuple.1 {
                    future.notify(error: error)
                    return
                }
                if let httpResp = callbackTuple.0 {
                    future.notify(response: httpResp)
                    return
                }
                assert(false, "alamofire 请求结束后居然既没有error又没有response，介不可能！！！！")
            })
            dataRequest.downloadProgress(queue: self.queue, closure: { (progress) in
                future.notify(progress: progress)
            })
        }catch let err {
            let error = AlamofireClientError.adaptAlamofireRequestFailed(rawError: err)
            self.queue.async {
                future.notify(error: error)
            }
        }
        return future
    }
    
    func adapt(_ request: HTTPRequest) -> HTTPMethod {
        return HTTPMethod(rawValue: request.method) ?? .get
    }
    
    func adapt(_ request: HTTPRequest) throws -> DataRequest {
        var urlRequest = try URLRequest(url: request.url, method: adapt(request), headers: request.headers)
        urlRequest.httpBody = try request.body()
        return Alamofire.request(urlRequest)
    }
    
    func adapt(response: DataResponse<Data>, request: HTTPRequest) -> (HTTPResponse?, HIError?) {
        switch response.result {
        case .success(let data):
                guard let rawResponse = response.response else {
                    return (nil, AlamofireClientError.missingResponse(request: request))
                }
                //TODO: handle header fields
                return (HTTPBaseResponse(with: rawResponse.statusCode, headers: rawResponse.allHeaderFields as! [String : String], body: data, request: request), nil)
        case .failure(let error):
                return (nil, AlamofireClientError.adaptAlamofireResponseFailed(rawError: error))
        }
    }
}

