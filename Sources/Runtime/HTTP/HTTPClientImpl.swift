//
//  HTTPRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation
import Alamofire

enum AlamofireClientError: Error {
    case missingResponse
}

struct AlamofireClient: HTTPClient {
    
    func send(_ request: HTTPRequest, completion: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
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
            errorHandler(err)
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
    
    func adapt(response: DataResponse<Data>, request: HTTPRequest) -> (HTTPResponse?, Error?) {
        switch response.result {
        case .success(let data):
                guard let rawResponse = response.response else {
                    return (nil, AlamofireClientError.missingResponse)
                }
                return (HTTPBaseResponse(with: rawResponse.statusCode, headers: rawResponse.allHeaderFields as! [String : String], body: data, request: request), nil)
        case .failure(let error):
                return (nil, error)
        }
    }
}

