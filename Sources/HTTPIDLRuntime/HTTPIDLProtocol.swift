//
//  HTTPIDLProtocol.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/12/1.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import Foundation

protocol HTTPIDLParameterKey {
    func asHTTPParamterKey() -> String
}

protocol HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String) -> HTTPIDLParameter
}

protocol HTTPIDLRequest {
    static var defaultMethod: String {get}
    var method: String {get}
    var configuration: HTTPIDLConfiguration {get set}
    var uri: String {get}
    var parameters: [HTTPIDLParameter] {get}
}

protocol HTTPIDLClient {
    func send<ResponseType: HTTPIDLResponse>(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (_ repsonse: ResponseType?, _ error: Error?) -> Void)
    func send(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (_ repsonse: HTTPResponse?, _ error: Error?) -> Void)
}

protocol HTTPRequestEncoder {
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest
}

protocol HTTPIDLResponse {
    init(httpResponse: HTTPResponse) throws
}

protocol HTTPResponseBodyDecoder {
    associatedtype OutputType
    func decode(_ responseBody: Data) throws -> OutputType
}
