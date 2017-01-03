//
//  HTTPIDLParameter.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/2.
//  Copyright © 2017年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

public enum HTTPIDLParameter {
    case int64(key: String, value: Int64)
    case int32(key: String, value: Int32)
    case double(key: String, value: Double)
    case string(key: String, value: String)
    case file(key: String, value: URL, fileName: String?, mimeType: String?)
    case data(key: String, value: Data, fileName: String?, mimeType: String?)
    case array(key: String, value: [HTTPIDLParameter])
    case dictionary(key: String, value: [String: HTTPIDLParameter])
    
    var key: String {
        get {
            switch self {
                case .int64(let key, _):
                    return key
                case .int32(let key, _):
                    return key
                case .double(let key, _):
                    return key
                case .string(let key, _):
                    return key
                case .file(let key, _, _, _):
                    return key
                case .data(let key, _, _, _):
                    return key
                case .array(let key, _):
                    return key
                case .dictionary(let key, _):
                    return key
            }
        }
    }
}

public enum HTTPIDLParameterEncodeError: Error {
    case EncodeToStringFailed
}

extension Int64: HTTPIDLParameterKey {
    public func asHTTPParamterKey() -> String {
        return String(self)
    }
}

extension Int64: HTTPIDLParameterConvertible {
    public func asHTTPIDLParameter(key: String) -> HTTPIDLParameter {
        return .int64(key: key, value: self)
    }
}

extension Int32: HTTPIDLParameterKey {
    public func asHTTPParamterKey() -> String {
        return String(self)
    }
}

extension Int32: HTTPIDLParameterConvertible {
    public func asHTTPIDLParameter(key: String) -> HTTPIDLParameter {
        return .int32(key: key, value: self)
    }
}

extension Double: HTTPIDLParameterKey {
    public func asHTTPParamterKey() -> String {
        return String(self)
    }
}

extension Double: HTTPIDLParameterConvertible {
    public func asHTTPIDLParameter(key: String) -> HTTPIDLParameter {
        return .double(key: key, value: self)
    }
}

extension String: HTTPIDLParameterKey {
    public func asHTTPParamterKey() -> String {
        return self
    }
}

extension String: HTTPIDLParameterConvertible {
    public func asHTTPIDLParameter(key: String) -> HTTPIDLParameter {
        return .string(key: key, value: self)
    }
}

extension Array where Element: HTTPIDLParameterConvertible {
    public func asHTTPIDLParameter(key: String) -> HTTPIDLParameter {
        let value = self.map ({ (convertible) in
            return convertible.asHTTPIDLParameter(key: key)
        })
        return .array(key: key, value: value)
    }
}

extension Dictionary where Key: HTTPIDLParameterKey, Value: HTTPIDLParameterConvertible {
    public func asHTTPIDLParameter(key: String) -> HTTPIDLParameter {
        let value = self.reduce([String: HTTPIDLParameter]()) { (soFar, soGood) -> [String: HTTPIDLParameter] in
            var result = soFar
            result[soGood.key.asHTTPParamterKey()] = soGood.value.asHTTPIDLParameter(key: key)
            return result
        }
        return .dictionary(key: key, value: value)
    }
}

extension HTTPData: HTTPIDLParameterConvertible {
    public func asHTTPIDLParameter(key: String) -> HTTPIDLParameter {
        return .data(key: key, value: payload, fileName: fileName, mimeType: mimeType)
    }
}

extension HTTPFile: HTTPIDLParameterConvertible {
    public func asHTTPIDLParameter(key: String) ->
        HTTPIDLParameter {
        return .file(key: key, value: payload, fileName: fileName, mimeType: mimeType)
    }
}
