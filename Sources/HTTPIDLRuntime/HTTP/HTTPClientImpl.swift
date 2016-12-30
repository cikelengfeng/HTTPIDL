//
//  HTTPRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation
import Alamofire

struct AlamofireClient: HTTPClient {
    
    func send(_ request: HTTPRequest, completion: @escaping (HTTPResponse?, Error?) -> Void) {
        do {
            let dataRequest: DataRequest = try adapt(request)
            dataRequest.responseData(completionHandler: { (response) in
                let callbackTuple = self.adapt(response)
                completion(callbackTuple.0, callbackTuple.1)
            })
        }catch let err {
            completion(nil, err)
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
    
    func adapt(_ response: DataResponse<Data>) -> (HTTPResponse?, Error?) {
        switch response.result {
        case .success(let data):
                guard let rawResponse = response.response else {
                    return (nil, nil)
                }
                return (HTTPBaseResponse(with: rawResponse.statusCode, headers: rawResponse.allHeaderFields as! [String : String], body: data), nil)
        case .failure(let error):
                return (nil, error)
        }
    }
}

