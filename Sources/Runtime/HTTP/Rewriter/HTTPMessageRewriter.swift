//
//  File.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/5.
//
//

import Foundation

public enum HTTPRequestRewriterResult {
    case rewrite(request: HTTPRequest)
    case toError(error: Error)
}

public protocol HTTPRequestRewriter {
    func shouldContinue(request: HTTPRequest) -> Bool
    func rewrite(request: HTTPRequest) -> HTTPRequest
}

public enum HTTPResponseRewriterResult {
    case rewrite(response: HTTPResponse)
    case toError(error: Error)
}

protocol HTTPResponseRewriter {
    func rewrite(response: HTTPResponse) -> HTTPResponseRewriterResult
}
