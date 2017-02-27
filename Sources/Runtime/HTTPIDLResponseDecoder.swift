//
//  ResponseBodyDecoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//

import Foundation

private func decode(json: Any) throws -> ResponseContent {
    if let number = json as? NSNumber {
        let numberType = CFNumberGetType(number)
        switch numberType {
        case .charType:
            return .bool(value: number as Bool)
        //Bool
        case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .shortType, .intType, .longType, .longLongType, .cfIndexType, .nsIntegerType:
        //Int
            return .int64(value: number as Int64)
        case .float32Type, .float64Type, .floatType, .doubleType, .cgFloatType:
            if number.isKind(of: NSDecimalNumber.self) {
                if String(number.int64Value) == String(number.uint64Value) {
                    return .int64(value: number.int64Value)
                }
            }
            //Double
            return .double(value: number as Double)
        }
    }else if let tmp = json as? String {
        return .string(value: tmp)
    } else if let tmp = json as? [Any] {
        return .array(value: try tmp.map({
            return try decode(json: $0)
        }))
    } else if json is [String: Any], let tmp = json as? [String: Any] {
        return .dictionary(value: try tmp.reduce([String: ResponseContent](), { (soFar, soGood) in
            var ret = soFar
            ret[soGood.key] = try decode(json: soGood.value)
            return ret
        }))
    }else {
        throw HTTPResponseJSONDecoderError.unsupportedParameterType(value: json)
    }
}

private func decodeRoot(json: Any) throws -> ResponseContent {
    if let tmp = json as? [String: Any] {
        return .dictionary(value: try tmp.reduce([String: ResponseContent](), { (soFar, soGood) in
            var ret = soFar
            ret[soGood.key] = try decode(json: soGood.value)
            return ret
        }))
    } else {
        throw HTTPResponseJSONDecoderError.illegalJSONObject(errorSource: json)
    }
}

public enum HTTPResponseJSONDecoderError: HIError {
    case illegalJSONObject(errorSource: Any)
    case unsupportedParameterType(value: Any)
    case JSONSerializationError(rawError: Error)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .illegalJSONObject(let errorSource):
                return "response json decoder error: response不是字典类型，导致无法给response的属性赋值, error source: \(errorSource)"
            case .unsupportedParameterType(let value):
                return "response json decoder error: 不支持的参数类型 value: \(value)"
            case .JSONSerializationError(let rawError):
                return (rawError as NSError).localizedDescription
            }
        }
    }
}

public struct HTTPResponseJSONDecoder: HTTPResponseDecoder {
    
    public static let shared = HTTPResponseJSONDecoder()
    public var jsonReadOptions: JSONSerialization.ReadingOptions = .allowFragments
    
    public func decode(_ response: HTTPResponse) throws -> ResponseContent? {
        guard let body = response.body else {
            return nil
        }
        let json: Any
        do {
            json = try JSONSerialization.jsonObject(with: body, options: jsonReadOptions)
        } catch let error as NSError {
            throw HTTPResponseJSONDecoderError.JSONSerializationError(rawError: error)
        }
            
        return try decodeRoot(json: json)
    }
}
