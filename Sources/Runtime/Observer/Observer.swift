//
//  HTTPMessageObserver.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/3//

import Foundation

public protocol RequestObserver: class {
    func willSend(request: Request)
    func didSend(request: Request)
    func willEncode(request: Request)
    func didEncode(request: Request, encoded: HTTPRequest)
}

public protocol ResponseObserver: class {
    func receive(error: HIError, request: Request)
    func receive(rawResponse: HTTPResponse)
    func willDecode(rawResponse: HTTPResponse)
    func didDecode(rawResponse: HTTPResponse, decodedResponse: Response)
}
