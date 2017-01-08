//
//  HTTPIDLRequestParameter.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/2.
//  Copyright © 2017年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

public enum HTTPIDLRequestParameter {
    case int64(key: String, value: Int64)
    case int32(key: String, value: Int32)
    case double(key: String, value: Double)
    case string(key: String, value: String)
    case file(key: String, value: URL, fileName: String?, mimeType: String?)
    case data(key: String, value: Data, fileName: String?, mimeType: String?)
    case array(key: String, value: [HTTPIDLRequestParameter])
    case dictionary(key: String, value: [String: HTTPIDLRequestParameter])
    
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

extension Int64: HTTPIDLRequestParameterKey {
    public func asHTTPParamterKey() -> String {
        return String(self)
    }
}

extension Int64: HTTPIDLRequestParameterConvertible {
    public func asHTTPIDLRequestParameter(key: String) -> HTTPIDLRequestParameter {
        return .int64(key: key, value: self)
    }
}

extension Int32: HTTPIDLRequestParameterKey {
    public func asHTTPParamterKey() -> String {
        return String(self)
    }
}

extension Int32: HTTPIDLRequestParameterConvertible {
    public func asHTTPIDLRequestParameter(key: String) -> HTTPIDLRequestParameter {
        return .int32(key: key, value: self)
    }
}

extension Double: HTTPIDLRequestParameterKey {
    public func asHTTPParamterKey() -> String {
        return String(self)
    }
}

extension Double: HTTPIDLRequestParameterConvertible {
    public func asHTTPIDLRequestParameter(key: String) -> HTTPIDLRequestParameter {
        return .double(key: key, value: self)
    }
}

extension String: HTTPIDLRequestParameterKey {
    public func asHTTPParamterKey() -> String {
        return self
    }
}

extension String: HTTPIDLRequestParameterConvertible {
    public func asHTTPIDLRequestParameter(key: String) -> HTTPIDLRequestParameter {
        return .string(key: key, value: self)
    }
}

extension Array where Element: HTTPIDLRequestParameterConvertible {
    public func asHTTPIDLRequestParameter(key: String) -> HTTPIDLRequestParameter {
        let value = self.map ({ (convertible) in
            return convertible.asHTTPIDLRequestParameter(key: key)
        })
        return .array(key: key, value: value)
    }
}

extension Dictionary where Key: HTTPIDLRequestParameterKey, Value: HTTPIDLRequestParameterConvertible {
    public func asHTTPIDLRequestParameter(key: String) -> HTTPIDLRequestParameter {
        let value = self.reduce([String: HTTPIDLRequestParameter]()) { (soFar, soGood) -> [String: HTTPIDLRequestParameter] in
            var result = soFar
            result[soGood.key.asHTTPParamterKey()] = soGood.value.asHTTPIDLRequestParameter(key: key)
            return result
        }
        return .dictionary(key: key, value: value)
    }
}

extension HTTPData: HTTPIDLRequestParameterConvertible {
    public func asHTTPIDLRequestParameter(key: String) -> HTTPIDLRequestParameter {
        return .data(key: key, value: payload, fileName: fileName, mimeType: mimeType)
    }
}

extension HTTPFile: HTTPIDLRequestParameterConvertible {
    public func asHTTPIDLRequestParameter(key: String) ->
        HTTPIDLRequestParameter {
        return .file(key: key, value: payload, fileName: fileName, mimeType: mimeType)
    }
}
