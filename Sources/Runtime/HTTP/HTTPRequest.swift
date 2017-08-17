//
//  HTTPRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30//

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

public struct HTTPBaseRequest: HTTPRequest {
    public var method: String
    public var headers: [String: String]
    public var url: URL
    public var bodyStream: InputStream?
    public var cachePolicy: URLRequest.CachePolicy?
    public var networkServiceType: URLRequest.NetworkServiceType?
    public var timeoutInterval: TimeInterval?
    public var shouldUsePipelining: Bool?
    public var shouldHandleCookies: Bool?
    public var allowsCellularAccess: Bool? 
    
    public init(method: String, url: URL, headers: [String: String], bodyStream: InputStream?) {
        self.method = method
        self.url = url
        self.headers = headers
        self.bodyStream = bodyStream
    }
    
    public init(httpRequest: HTTPRequest) {
        self.init(method: httpRequest.method, url: httpRequest.url, headers: httpRequest.headers, bodyStream: httpRequest.bodyStream)
        cachePolicy = httpRequest.cachePolicy
        networkServiceType = httpRequest.networkServiceType
        timeoutInterval = httpRequest.timeoutInterval
        shouldUsePipelining = httpRequest.shouldUsePipelining
        shouldHandleCookies = httpRequest.shouldHandleCookies
        allowsCellularAccess = httpRequest.allowsCellularAccess
    }
    
}
