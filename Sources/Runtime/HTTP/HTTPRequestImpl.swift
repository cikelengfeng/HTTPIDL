//
//  HTTPRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct HTTPBaseRequest: HTTPRequest {
    var method: String
    var headers: [String: String]
    var url: URL
    var body: () throws -> Data?
    
    init(method: String, url: URL, headers: [String: String], body: @escaping () throws -> Data?) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
    }
}
