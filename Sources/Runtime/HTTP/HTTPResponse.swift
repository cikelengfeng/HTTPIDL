//
//  HTTPResponseImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28//

import Foundation

public protocol HTTPResponse {
    var statusCode: Int {get}
    var headers: [String: String] {get}
    var bodyStream: OutputStream? {get}
    var request: HTTPRequest {get}
}

public struct HTTPBaseResponse: HTTPResponse {
    
    public var statusCode: Int
    public var headers: [String: String]
    public var bodyStream: OutputStream?
    public var request: HTTPRequest
    
    public init(with statusCode: Int, headers: [String: String], bodyStream: OutputStream?, request: HTTPRequest) {
        self.statusCode = statusCode
        self.headers = headers
        self.bodyStream = bodyStream
        self.request = request
    }
}
