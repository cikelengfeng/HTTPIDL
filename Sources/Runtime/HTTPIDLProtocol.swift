//
//  HTTPIDLProtocol.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/12/1.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import Foundation

public protocol HTTPIDLParameterKey {
    func asHTTPParamterKey() -> String
}

public protocol HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String) -> HTTPIDLParameter
}

public protocol HTTPIDLRequest {
    static var defaultMethod: String {get}
    var method: String {get}
    var configuration: HTTPIDLConfiguration {get set}
    var uri: String {get}
    var parameters: [HTTPIDLParameter] {get}
}

public protocol HTTPIDLClient {
    func send<ResponseType: HTTPIDLResponse>(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (_ repsonse: ResponseType) -> Void, errorHandler: ((_ error: Error) -> Void)?)
    func send(_ request: HTTPIDLRequest, requestEncoder: HTTPRequestEncoder, completion: @escaping (_ repsonse: HTTPResponse) -> Void, errorHandler: ((_ error: Error) -> Void)?)
    
    mutating func add(requestObserver: HTTPRequestObserver)
    mutating func remove(requestObserver: HTTPRequestObserver)
    mutating func add(responseObserver: HTTPResponseObserver)
    mutating func remove(responseObserver: HTTPResponseObserver)
    mutating func add(requestRewriter: HTTPRequestRewriter)
    mutating func remove(requestRewriter: HTTPRequestRewriter)
    mutating func add(responseRewriter: HTTPResponseRewriter)
    mutating func remove(responseRewriter: HTTPResponseRewriter)
}

public protocol HTTPRequestEncoder {
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest
}

public protocol HTTPIDLResponse {
    init(httpResponse: HTTPResponse) throws
}

public protocol HTTPResponseBodyDecoder {
    associatedtype OutputType
    func decode(_ responseBody: Data) throws -> OutputType
}
