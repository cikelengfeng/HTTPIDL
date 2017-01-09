//
//  HTTPMessageObserver.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/3.
//  Copyright © 2017年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

public protocol HTTPRequestObserver: class {
    func willSend(request: Request)
    func didSend(request: Request)
    func willEncode(request: Request)
    func didEncode(request: Request, encoded: HTTPRequest)
}

public protocol HTTPResponseObserver: class {
    func receive(error: HIError)
    func receive(rawResponse: HTTPResponse)
    func willDecode(rawResponse: HTTPResponse)
    func didDecode(rawResponse: HTTPResponse, decodedResponse: Response)
}
