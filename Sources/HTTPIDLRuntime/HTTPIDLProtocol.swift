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
    var value: () throws -> Data {get}
    var fileName: String? {get}
    var mimeType: String? {get}
}

protocol HTTPIDLRequest {
    var configration: HTTPIDLConfiguration {get set}
    var method: String {get set}
    var uri: String {get set}
    var parameters: [HTTPIDLParameter] {get}
}

protocol HTTPIDLClient {
    func send<ResponseType: HTTPIDLResponse>(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (_ repsonse: ResponseType?, _ error: Error?) -> Void)
}

protocol HTTPRequestEncoder {
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest
}

protocol HTTPIDLResponse {
    init(with httpResponse: HTTPResponse) throws
}

protocol HTTPResponseBodyDecoder {
    associatedtype OutputType
    func decode(_ responseBody: Data) throws -> OutputType
}
