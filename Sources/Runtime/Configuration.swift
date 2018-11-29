//
//  Config.swift
//  Demo
//
//  Created by 徐 东 on 2016/11/30//  Copyright © 2016年 dx lab. All rights reserved//

import Foundation

public protocol RequestManagerConfiguration {
    var baseURLString: String {get set}
    var headers: [String: String] {get set}
    var callbackQueue: DispatchQueue {get set}
    var encoderStrategy: (Request) -> Encoder {get set}
    var decoderStrategy: (Request) -> Decoder {get set}
    
    mutating func append(headers: [String: String])
}

public protocol RequestConfiguration {
    var baseURLString: String {get set}
    var headers: [String: String] {get set}
    var callbackQueue: DispatchQueue {get set}
    var encoder: Encoder {get set}
    var decoder: Decoder {get set}
    var cachePolicy: CachePolicy? {get set}
    var networkServiceType: NetworkServiceType? {get set}
    var timeoutInterval: TimeInterval? {get set}
    var shouldUsePipelining: Bool? {get set}
    var shouldHandleCookies: Bool? {get set}
    var allowsCellularAccess: Bool? {get set}
    var bodyStreaming: Bool? {get set}
    
    mutating func append(headers: [String: String])
}

public func convert(cachePolicy: CachePolicy) -> URLRequest.CachePolicy {
    switch cachePolicy {
    case .useProtocolCachePolicy: return .useProtocolCachePolicy
    case .reloadIgnoringLocalCacheData: return .reloadIgnoringLocalCacheData
    case .returnCacheDataElseLoad: return .returnCacheDataElseLoad
    case .returnCacheDataDontLoad: return .returnCacheDataDontLoad
    }
}

public func convert(networkServiceType: NetworkServiceType) -> URLRequest.NetworkServiceType {
    switch networkServiceType {
    case .default: return .default
    case .voip: return .voip
    case .video: return .video
    case .background: return .background
    case .voice: return .voice
    case .networkServiceTypeCallSignaling: if #available(iOS 10.0, *) {
        return .callSignaling
    } else {
        return .default
        }
    }
}

public enum CachePolicy : UInt {
    
    case useProtocolCachePolicy
    
    case reloadIgnoringLocalCacheData
    
    case returnCacheDataElseLoad
    
    case returnCacheDataDontLoad
}

public enum NetworkServiceType : UInt {
    
    case `default` // Standard internet traffic
    
    case voip // Voice over IP control traffic
    
    case video // Video traffic
    
    case background // Background traffic
    
    case voice // Voice data
    
//    @available(iOS 10.0, *)
    case networkServiceTypeCallSignaling // Call Signaling
}

public struct BaseRequestManagerConfiguration: RequestManagerConfiguration {
    public static var shared = BaseRequestManagerConfiguration()
    
    public var baseURLString: String = ""
    public var headers: [String: String] = [:]
    public var callbackQueue: DispatchQueue = DispatchQueue.main
    public var encoderStrategy: (Request) -> Encoder = { (request) in
        switch request.method {
        case "PUT", "POST", "PATCH":
            return URLEncodedFormEncoder.shared
        default:
            return URLEncodedQueryEncoder.shared
        }
    }
    
    public var decoderStrategy: (Request) -> Decoder = { (request) in
        return JSONDecoder()
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

public struct BaseRequestConfiguration: RequestConfiguration {

    public var baseURLString: String = ""
    public var headers: [String: String] = [:]
    public var callbackQueue: DispatchQueue
    public var encoder: Encoder
    public var decoder: Decoder
    public var allowsCellularAccess: Bool?
    public var shouldHandleCookies: Bool?
    public var shouldUsePipelining: Bool?
    public var timeoutInterval: TimeInterval?
    public var networkServiceType: NetworkServiceType?
    public var cachePolicy: CachePolicy?
    public var bodyStreaming: Bool?
    
    public mutating func append(headers: [String: String]) {
        let newHeader = headers.reduce(self.headers , { (soFar, soGood) in
            var mutableSoFar = soFar
            mutableSoFar[soGood.0] = soGood.1
            return mutableSoFar
        })
        self.headers = newHeader
    }
    
    public static func create(from clientConfiguration: RequestManagerConfiguration, request: Request) -> RequestConfiguration {
        return BaseRequestConfiguration(baseURLString: clientConfiguration.baseURLString, headers: clientConfiguration.headers, callbackQueue: clientConfiguration.callbackQueue, encoder: clientConfiguration.encoderStrategy(request), decoder: clientConfiguration.decoderStrategy(request), allowsCellularAccess: nil, shouldHandleCookies: nil, shouldUsePipelining: nil, timeoutInterval: nil, networkServiceType: nil, cachePolicy: nil, bodyStreaming: nil)
    }
}

