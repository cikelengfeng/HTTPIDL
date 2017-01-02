//
//  HTTPIDLParameter.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/2.
//  Copyright © 2017年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

enum HTTPIDLParameter {
    case int64(key: String, value: Int64)
    case int32(key: String, value: Int32)
    case double(key: String, value: Double)
    case string(key: String, value: String)
    case file(key: String, value: URL, fileName: String?, mimeType: String?)
    case data(key: String, value: Data, fileName: String?, mimeType: String?)
    case array(key: String, value: [HTTPIDLParameter])
    case dictionary(key: String, value: [String: HTTPIDLParameter])
}

enum HTTPIDLParameterEncodeError: Error {
    case EncodeToStringFailed
}

extension Int64: HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String, fileName: String?, mimeType: String?) -> HTTPIDLParameter {
        return .int64(key: key, value: self)
    }
}

extension Int32: HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String, fileName: String?, mimeType: String?) -> HTTPIDLParameter {
        return .int32(key: key, value: self)
    }
}

extension Double: HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String, fileName: String?, mimeType: String?) -> HTTPIDLParameter {
        return .double(key: key, value: self)
    }
}

extension String: HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String, fileName: String?, mimeType: String?) -> HTTPIDLParameter {
        return .string(key: key, value: self)
    }
}

extension Array where Element: HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String, fileName: String?, mimeType: String?) -> HTTPIDLParameter {
        let value = self.map ({ (convertible) in
            return convertible.asHTTPIDLParameter(key: key, fileName: fileName, mimeType: mimeType)
        })
        return .array(key: key, value: value)
    }
}

extension Dictionary where Key: String, Value: HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String, fileName: String?, mimeType: String?) -> HTTPIDLParameter {
        let value = self.reduce([String: HTTPIDLParameter]()) { (soFar, soGood) -> [String: HTTPIDLParameter] in
            var result = soFar
            result[soGood.key] = soGood.value.asHTTPIDLParameter(key: key, fileName: fileName, mimeType: mimeType)
            return result
        }
        return .dictionary(key: key, value: value)
    }
}

extension MultipartData: HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String, fileName: String?, mimeType: String?) -> HTTPIDLParameter {
        return .data(key: key, value: payload, fileName: self.fileName, mimeType: self.mimeType)
    }
}

extension MultipartFile: HTTPIDLParameterConvertible {
    func asHTTPIDLParameter(key: String, fileName: String?, mimeType: String?) ->
        HTTPIDLParameter {
        return .file(key: key, value: payload, fileName: self.fileName, mimeType: self.mimeType)
    }
}
