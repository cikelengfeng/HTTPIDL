//
//  HTTPIDLBaseClient.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct HTTPIDLBaseClient: HTTPIDLClient {
    var clientImpl: HTTPClient = AlamofireClient()
    
    func send<ResponseType : HTTPIDLResponse>(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder = HTTPBaseRequestEncoder.shared, completion: @escaping (ResponseType?, Error?) -> Void) {
        do {
            let encodedRequest = try requestEncoder.encode(request)
            clientImpl.send(encodedRequest) { (clientResponse, clientError) in
                do {
                    guard let clientResponse = clientResponse else {
                        completion(nil, clientError)
                        return
                    }
                    let httpIdlResponse = try ResponseType(httpResponse: clientResponse)
                    completion(httpIdlResponse, clientError)
                } catch let error {
                    completion(nil, error)
                }
            }
        } catch let error {
            completion(nil, error)
        }
    }
    
    func send(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (HTTPResponse?, Error?) -> Void) {
        do {
            let encodedRequest = try requestEncoder.encode(request)
            clientImpl.send(encodedRequest) { (clientResponse, clientError) in
                guard let clientResponse = clientResponse else {
                    completion(nil, clientError)
                    return
                }
                completion(clientResponse, clientError)
            }
        } catch let error {
            completion(nil, error)
        }
    }
}
