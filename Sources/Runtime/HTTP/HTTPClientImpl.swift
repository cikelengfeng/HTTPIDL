//
//  HTTPRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation
import Alamofire

enum AlamofireClientError: HIError {
    case missingResponse(request: HTTPRequest)
    case adaptAlamofireRequestFailed(rawError: Error)
    case adaptAlamofireResponseFailed(rawError: Error)
    
    var errorDescription: String? {
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

struct AlamofireClient: HTTPClient {
    
    func send(_ request: HTTPRequest, completion: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        do {
            let dataRequest: DataRequest = try adapt(request)
            dataRequest.responseData(completionHandler: { (response) in
                let callbackTuple = self.adapt(response: response, request: request)
                if let error = callbackTuple.1 {
                    errorHandler(error)
                    return
                }
                if let httpResp = callbackTuple.0 {
                    completion(httpResp)
                    return
                }
                assert(false, "alamofire 请求结束后居然既没有error又没有response，介不可能！！！！")
            })
        }catch let err {
            errorHandler(AlamofireClientError.adaptAlamofireRequestFailed(rawError: err))
        }
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

