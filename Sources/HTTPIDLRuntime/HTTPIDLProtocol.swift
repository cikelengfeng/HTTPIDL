//
//  HTTPIDLProtocol.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/12/1.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import Foundation

protocol RawHTTPResponseWrapper {
    var rawResponse: HTTPURLResponse? {get}
}

protocol HTTPIDLParameter {
    var key: String {get}
    var value: () throws -> String {get}
}

protocol HTTPIDLRequest {
    var parameters: [HTTPIDLParameter] {get set}
    var encoder: HTTPRequestEncoder {get set}
    var client: HTTPClient {get set}
}

protocol HTTPIDLResponse {
    var httpResponse: HTTPResponse? {get}
}

protocol HTTPRequestEncoder {
    func encode(_ request: HTTPIDLRequest) -> HTTPRequest?
}

protocol HTTPResponseDecoder {
    func decode(_ response: HTTPResponse) -> HTTPIDLResponse?
}

