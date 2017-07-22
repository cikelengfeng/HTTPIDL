//
//  RequestProtocol.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28//

import Foundation

public protocol HTTPRequest {
    
    var method: String {get set}
    var headers: [String: String] {get set}
    var url: URL {get set}
    //有些情况下request body可以为空，如GET请求。所以这里要同时支持抛错和空值
    var bodyStream: InputStream? {get set}
    
    var cachePolicy: URLRequest.CachePolicy? {get set}
    var networkServiceType: URLRequest.NetworkServiceType? {get set}
    var timeoutInterval: TimeInterval? {get set}
    var shouldUsePipelining: Bool? {get set}
    var shouldHandleCookies: Bool? {get set}
    var allowsCellularAccess: Bool? {get set}
    
}

public protocol HTTPResponse {
    var statusCode: Int {get}
    var headers: [String: String] {get}
    var body: Data? {get}
    var request: HTTPRequest {get}
}


public protocol HTTPClient {
    func send(_ request: HTTPRequest) -> HTTPRequestFuture
}

public protocol HTTPRequestFuture: class {
    
    var request: HTTPRequest {get}
    var progressHandler: ((_ progress: Progress) -> Void)? {get set}
    var responseHandler: ((_ response: HTTPResponse) -> Void)? {get set}
    var errorHandler: ((_ error: HIError) -> Void)? {get set}
    
    func cancel()
    func notify(progress: Progress)
    func notify(response: HTTPResponse)
    func notify(error: HIError)
}
