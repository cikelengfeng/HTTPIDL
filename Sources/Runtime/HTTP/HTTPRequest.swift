//
//  HTTPRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30//

import Foundation

public struct HTTPBaseRequest: HTTPRequest {
    public var method: String
    public var headers: [String: String]
    public var url: URL
    public var body: () throws -> Data?
    
    public init(method: String, url: URL, headers: [String: String], body: @escaping () throws -> Data?) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
    }
    
    public init(httpRequest: HTTPRequest) {
        self.init(method: httpRequest.method, url: httpRequest.url, headers: httpRequest.headers, body: httpRequest.body)
    }
    
}
