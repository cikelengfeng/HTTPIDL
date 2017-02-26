//
//  Config.swift
//  Demo
//
//  Created by 徐 东 on 2016/11/30//  Copyright © 2016年 dx lab. All rights reserved//

import Foundation
import Alamofire

public protocol Configuration {
    var baseURLString: String {get set}
    var headers: [String: String] {get set}
    var callbackQueue: DispatchQueue {get set}
    var defaultEncoderStrategy: (Request) -> HTTPRequestEncoder {get set}
    var defaultDecoderStrategy: (Request) -> HTTPResponseDecoder {get set}
    
    mutating func append(headers: [String: String])
}

public struct BaseConfiguration: Configuration {
    public static var shared = BaseConfiguration()
    
    public var baseURLString: String = ""
    public var headers: [String: String] = [:]
    public var callbackQueue: DispatchQueue = DispatchQueue.main
    public var defaultEncoderStrategy: (Request) -> HTTPRequestEncoder = { (request) in
        switch request.method {
        case "PUT", "POST", "PATCH":
            return HTTPURLEncodedFormRequestEncoder.shared
        default:
            return HTTPURLEncodedQueryRequestEncoder.shared
        }
    }
    
    public var defaultDecoderStrategy: (Request) -> HTTPResponseDecoder = { (request) in
        return HTTPResponseJSONDecoder.shared
    }
    
    public mutating func append(headers: [String: String]) {
        let newHeader = headers.reduce(self.headers , { (soFar, soGood) in
            var mutableSoFar = soFar
            mutableSoFar[soGood.0] = soGood.1
            return mutableSoFar
        })
        self.headers = newHeader
    }
}

