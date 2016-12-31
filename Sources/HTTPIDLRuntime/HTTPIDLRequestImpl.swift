//
//  HTTPIDLRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct HTTPIDLBaseRequest: HTTPIDLRequest {
    
    var parameters: [HTTPIDLParameter] = []
    var encoder: HTTPRequestEncoder = HTTPBaseRequestEncoder()
    var client: HTTPClient = AlamofireClient()
    
    func send<Response: HTTPIDLResponse>(_ completion: @escaping (_ repsonse: Response?, _ error: Error?) -> Void) {
        do {
            let encodedRequest = try encoder.encode(self)
            client.send(encodedRequest) { (clientResponse, clientError) in
                do {
                    guard let clientResponse = clientResponse else {
                        completion(nil, clientError)
                        return
                    }
                    let httpIdlResponse = try Response(with: clientResponse)
                    completion(httpIdlResponse, clientError)
                } catch let error {
                    completion(nil, error)
                }
            }
        } catch let error {
            completion(nil, error)
        }
    }
    
}
