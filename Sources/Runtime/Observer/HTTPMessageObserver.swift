//
//  HTTPMessageObserver.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/3.
//  Copyright © 2017年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

protocol HTTPRequestObserver: class {
    func willSend(request: HTTPIDLRequest)
    func didSend(request: HTTPIDLRequest)
    func willEncode(request: HTTPIDLRequest)
    func didEncode(request: HTTPIDLRequest, encoded: HTTPRequest)
}

protocol HTTPResponseObserver: class {
    func receive(error: Error)
    func receive(rawResponse: HTTPResponse)
    func willDecode(rawResponse: HTTPResponse)
    func didDecode(rawResponse: HTTPResponse, decodedResponse: HTTPIDLResponse)
}
