//
//  HTTPIDLRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

class HTTPIDLBaseRequest: HTTPIDLRequest {
    
    var parameters: [HTTPIDLParameter] = []
    var encoder: HTTPRequestEncoder = HTTPBaseRequestEncoder()
    
    func send<Response: HTTPIDLResponse>(_ completion: (_ repsonse: Response?, _ error: Error?) -> Void) {
        guard let encodedRequest = encoder.encode(self) else {
            //TODO error
            completion(nil, nil)
        }
        
    }
    
}
