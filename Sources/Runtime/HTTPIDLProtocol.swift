//
//  Protocol.swift
//  Demo
//
//  Created by 徐 东 on 2016/12/1//  Copyright © 2016年 dx lab. All rights reserved//

import Foundation

public protocol RequestContentKeyType {
    func asHTTPParamterKey() -> String
}

public protocol RequestContentConvertible {
    func asRequestContent() -> RequestContent
}

public protocol Request {
    static var defaultMethod: String {get}
    var method: String {get}
    var configuration: Configuration {get set}
    var uri: String {get}
    var content: RequestContent? {get}
}


public protocol HTTPRequestEncoder {
    func encode(_ request: Request) throws -> HTTPRequest
}

public protocol Response {
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws
}

public protocol HTTPResponseDecoder {
    func decode(_ response: HTTPResponse) throws -> ResponseContent?
}

public protocol Client {
    func send<ResponseType: Response>(_ request: Request, requestEncoder: HTTPRequestEncoder, responseDecoder: HTTPResponseDecoder) -> RequestFuture<ResponseType>
    func send(_ request: Request, requestEncoder: HTTPRequestEncoder) -> RequestFuture<HTTPResponse>
    
    mutating func add(requestObserver: HTTPRequestObserver)
    mutating func remove(requestObserver: HTTPRequestObserver)
    mutating func add(responseObserver: HTTPResponseObserver)
    mutating func remove(responseObserver: HTTPResponseObserver)
    mutating func add(requestRewriter: HTTPRequestRewriter)
    mutating func remove(requestRewriter: HTTPRequestRewriter)
    mutating func add(responseRewriter: HTTPResponseRewriter)
    mutating func remove(responseRewriter: HTTPResponseRewriter)
}
