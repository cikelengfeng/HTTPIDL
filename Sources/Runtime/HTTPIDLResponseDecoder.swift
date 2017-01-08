//
//  HTTPIDLResponseBodyDecoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

private func decode(json: Any) throws -> HTTPIDLResponseParameter {
    if let tmp = json as? Int64 {
        return .int64(value: tmp)
    } else if let tmp = json as? Int32 {
        return .int32(value: tmp)
    } else if let tmp = json as? Double {
        return .double(value: tmp)
    } else if let tmp = json as? String {
        return .string(value: tmp)
    } else if let tmp = json as? [Any] {
        return .array(value: try tmp.map({
            return try decode(json: $0)
        }))
    } else if let tmp = json as? [String: Any] {
        return .dictionary(value: try tmp.reduce([String: HTTPIDLResponseParameter](), { (soFar, soGood) in
            var ret = soFar
            ret[soGood.key] = try decode(json: soGood.value)
            return ret
        }))
    }else {
        throw HTTPResponseJSONDecoderError.unsupportedParameterType
    }
}

private func decodeRoot(json: Any) throws -> [String: HTTPIDLResponseParameter] {
    let ret:  [String: HTTPIDLResponseParameter]
    if let tmp = json as? [String: Any] {
        return try tmp.reduce([String: HTTPIDLResponseParameter](), { (soFar, soGood) in
            var ret = soFar
            ret[soGood.key] = try decode(json: soGood.value)
            return ret
        })
    } else {
        throw HTTPResponseJSONDecoderError.illegalJSONObject
    }
    return ret
}

public enum HTTPResponseJSONDecoderError: LocalizedError {
    case parameterKeyNotFound
    case illegalJSONObject
    case unsupportedParameterType
}

public struct HTTPResponseJSONDecoder: HTTPResponseDecoder {
    
    public static let shared = HTTPResponseJSONDecoder()
    public var jsonReadOptions: JSONSerialization.ReadingOptions = .allowFragments
    
    public func decode(_ response: HTTPResponse) throws -> [String: HTTPIDLResponseParameter] {
        guard let body = response.body else {
            return [:]
        }
        let json = try JSONSerialization.jsonObject(with: body, options: jsonReadOptions)
        
        return try decodeRoot(json: json)
    }
}
