//
//  HTTPResponseImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct HTTPBaseResponse: HTTPResponse {
    
    var statusCode: Int
    var headers: [String: String]
    var body: Data?
    var request: HTTPRequest
    
    init(with statusCode: Int, headers: [String: String], body: Data?, request: HTTPRequest) {
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
        self.request = request
    }
}
