//
//  RequestProtocol.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation


public protocol HTTPRequest {
    
    var method: String {get set}
    var headers: [String: String] {get set}
    var url: URL {get set}
    //有些情况下request body可以为空，如GET请求。所以这里要同时支持抛错和空值
    var body: () throws -> Data? {get set}
    
}

public protocol HTTPResponse {
    var statusCode: Int {get}
    var headers: [String: String] {get}
    var body: Data? {get}
    var request: HTTPRequest {get}
}


public protocol HTTPClient {
    func send(_ request: HTTPRequest, completion: @escaping (_ response: HTTPResponse?, _ error: Error?) -> Void)
}
