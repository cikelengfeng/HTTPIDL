//
//  File.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/5//
//

import Foundation

public enum RequestRewriterResult {
    case request(request: HTTPRequest)
    case response(response: HTTPResponse)
    case error(error: HIError)
}

public protocol RequestRewriter: class {
    func rewrite(request: HTTPRequest) -> RequestRewriterResult
}

public enum ResponseRewriterResult {
    case response(response: HTTPResponse)
    case error(error: HIError)
}

public protocol ResponseRewriter: class {
    func rewrite(response: HTTPResponse) -> ResponseRewriterResult
}
