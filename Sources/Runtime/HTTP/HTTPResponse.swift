//
//  HTTPResponseImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

public struct HTTPBaseResponse: HTTPResponse {
    
    public var statusCode: Int
    public var headers: [String: String]
    public var body: Data?
    public var request: HTTPRequest
    
    public init(with statusCode: Int, headers: [String: String], body: Data?, request: HTTPRequest) {
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
        self.request = request
    }
}
