//
//  File.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/5.
//
//

import Foundation

public enum HTTPRequestRewriterResult {
    case request(request: HTTPRequest)
    case response(response: HTTPResponse)
    case error(error: Error)
}

public protocol HTTPRequestRewriter: class {
    func rewrite(request: HTTPRequest) -> HTTPRequestRewriterResult
}

public enum HTTPResponseRewriterResult {
    case response(response: HTTPResponse)
    case error(error: Error)
}

public protocol HTTPResponseRewriter: class {
    func rewrite(response: HTTPResponse) -> HTTPResponseRewriterResult
}
