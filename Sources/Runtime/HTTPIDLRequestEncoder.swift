//
//  RequestEncoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation
import Alamofire
import Gzip

public enum HTTPBaseRequestEncoderError: HIError {
    case constructURLFailed(urlString: String)
    case nestedObjectInURLQuery(errorSource: Any)
    case missingParameterKey(parameter: RequestContent)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .constructURLFailed(let urlString):
                return "构造URL对象失败，原始url字符串: " + urlString
            case .nestedObjectInURLQuery(let errorSource):
                return "企图在query中加入嵌套的对象: \(errorSource)"
            case .missingParameterKey(let parameter):
                return "企图在query中加入没有key的参数: \(parameter)"
            }
        }
    }
}

private func queryItems(leafContent: RequestContent, key: String) throws -> [(String, String)] {
    switch leafContent {
    case .int64(let value):
        return [(key, String(value))]
    case .int32(let value):
        return [(key, String(value))]
    case .bool(let value):
        return [(key, value ? "1" : "0")]
    case .double(let value):
        return [(key, String(value))]
    case .string(let value):
        return [(key, value)]
    case .file(let url, _, _):
        return [(key, url.absoluteString)]
    case .data(let data, _, _):
        return [(key, String(data: data, encoding: String.Encoding.utf8) ?? "")]
    case .array(let values):
        return try values.flatMap ({ (contentInArray) -> [(String, String)] in
            switch contentInArray {
            case .int64, .int32, .bool, .double, .string, .file, .data:
                return try queryItems(leafContent: contentInArray, key: key)
            case .array, .dictionary:
                throw HTTPBaseRequestEncoderError.nestedObjectInURLQuery(errorSource: values)
            }
        })
    case .dictionary(_):
        throw HTTPBaseRequestEncoderError.nestedObjectInURLQuery(errorSource: leafContent)
    }
}

private func queryItems(rootContent: RequestContent) throws -> [(String, String)] {
    switch rootContent {
    case .int64, .int32, .bool, .double, .string, .array, .file, .data:
        throw HTTPBaseRequestEncoderError.missingParameterKey(parameter: rootContent)
    case .dictionary(let dict):
        return try dict.flatMap({ (pair) in
            return try queryItems(leafContent: pair.value, key: pair.key)
        })
    }
}

public struct HTTPURLEncodedQueryRequestEncoder: HTTPRequestEncoder {
    
    public static let shared = HTTPURLEncodedQueryRequestEncoder()
    
    public func encode(_ request: Request) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        guard let content = request.content else {
            return HTTPBaseRequest(method: request.method, url: url, headers: request.configuration.headers , body: { () -> Data? in
                return nil
            })
        }
        let query = try queryItems(rootContent: content)
        
        let encodedURL = url.appendQuery(pairs: query)
        
        return HTTPBaseRequest(method: request.method, url: encodedURL, headers: request.configuration.headers , body: { () -> Data? in
            return nil
        })
    }
}


public enum HTTPJSONRequestEncoderError: HIError {
    case fileIsForbidden(file: URL)
    case dataIsForbidden(data: Data)
    case illegalRootParameter(parameter: RequestContent)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .fileIsForbidden(_):
                return "json request encoder 不支持文件参数, \(self)"
            case .dataIsForbidden(_):
                return "json request encoder 不支持Data参数, \(self)"
            case .illegalRootParameter(let parameter):
                return "json request encoder 只支持数组和字典类型做根参数, 错误参数: \(parameter)"
            }
        }
    }
}

private extension RequestContent {
    
    func asJSONRoot() throws -> Any {
        switch self {
        case .int64, .int32, .bool, .double, .string:
            throw HTTPJSONRequestEncoderError.illegalRootParameter(parameter: self)
        case .file(let url, _, _):
            throw HTTPJSONRequestEncoderError.fileIsForbidden(file: url)
        case .data(let data, _, _):
            throw HTTPJSONRequestEncoderError.dataIsForbidden(data: data)
        case .array, .dictionary:
            return try self.asJSONObject()
        }
    }
    
    func asJSONObject() throws -> Any {
        switch self {
        case .int64(let value):
            return value
        case .int32(let value):
            return value
        case .bool(let value):
            return value
        case .double(let value):
            return value
        case .string(let value):
            return value
        case .file(let url, _, _):
            throw HTTPJSONRequestEncoderError.fileIsForbidden(file: url)
        case .data(let data, _, _):
            throw HTTPJSONRequestEncoderError.dataIsForbidden(data: data)
        case .array(let array):
            return try array.map({ (paramInArray) in
                return try paramInArray.asJSONObject()
            })
        case .dictionary(let dict):
            return try dict.reduce([:], { (soFar, soGood) in
                var result = soFar
                result[soGood.key] = try soGood.value.asJSONObject()
                return result
            })
        }
    }
}

public struct HTTPJSONRequestEncoder: HTTPRequestEncoder {
    
    public static let shared = HTTPJSONRequestEncoder()
    
    public func encode(_ request: Request) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        var headers = request.configuration.headers
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = "application/json"
        }
        let getJsonData = { () throws -> Data? in
            guard let rootParameter = request.content else {
                return nil
            }
            let jsonDict = try rootParameter.asJSONRoot()
            let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            return data
        }
        return HTTPBaseRequest(method: request.method, url: url, headers: headers, body: getJsonData)
    }
}

public enum HTTPMultipartRequestEncoderError: HIError {
    case unsupportedInt64(key: String, value: Int64)
    case unsupportedInt32(key: String, value: Int32)
    case unsupportedBool(key: String, value: Bool)
    case unsupportedIntDouble(key: String, value: Double)
    case unsupportedIntString(key: String, value: String)
    case arrayIsForbidden(key: String, value: [RequestContent])
    case dictionaryIsForbidden(key: String, value: [String: RequestContent])
    case missingParameterKey(parameter: RequestContent)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .unsupportedInt64(let key, let value):
                return "multipart request encoder error: 不支持的Int64, key : \(key), value: \(value)"
            case .unsupportedInt32(let key, let value):
                return "multipart request encoder error: 不支持的Int32, key : \(key), value: \(value)"
            case .unsupportedBool(let key, let value):
                return "multipart request encoder error: 不支持的Bool, key : \(key), value: \(value)"
            case .unsupportedIntDouble(let key, let value):
                return "multipart request encoder error: 不支持的Double, key : \(key), value: \(value)"
            case .unsupportedIntString(let key, let value):
                return "multipart request encoder error: 不支持的String, key : \(key), value: \(value)"
            case .arrayIsForbidden(let key, let value):
                return "multipart request encoder error: 不支持数组类型的参数, key : \(key), value: \(value)"
            case .dictionaryIsForbidden(let key, let value):
                return "multipart request encoder error: 不支持字典类型的参数, key : \(key), value: \(value)"
            case .missingParameterKey(let parameter):
                return "multipart request encoder error: 参数没有key, \(parameter)"
            }
        }
    }
}

fileprivate extension RequestContent {
    func insertInto(multipart: MultipartFormData, key: String) throws {
        switch self {
        case .int64(let value):
            guard let data = String(value).data(using: String.Encoding.utf8) else {
                throw HTTPMultipartRequestEncoderError.unsupportedInt64(key: key, value: value)
            }
            multipart.append(data, withName: key)
        case .int32(let value):
            guard let data = String(value).data(using: String.Encoding.utf8) else {
                throw HTTPMultipartRequestEncoderError.unsupportedInt32(key: key, value: value)
            }
            multipart.append(data, withName: key)
        case .bool(let value):
            guard let data = String(value).data(using: String.Encoding.utf8) else {
                throw HTTPMultipartRequestEncoderError.unsupportedBool(key: key, value: value)
            }
            multipart.append(data, withName: key)
        case .double(let value):
            guard let data = String(value).data(using: String.Encoding.utf8) else {
                throw HTTPMultipartRequestEncoderError.unsupportedIntDouble(key: key, value: value)
            }
            multipart.append(data, withName: key)
        case .string(let value):
            guard let data = value.data(using: String.Encoding.utf8) else {
                throw HTTPMultipartRequestEncoderError.unsupportedIntString(key: key, value: value)
            }
            multipart.append(data, withName: key)
        case .file(let url, let fileName, let mime):
            multipart.append(url, withName: key, fileName: fileName ?? UUID().uuidString, mimeType: mime ?? "application/octet-stream")
        case .data(let data, let fileName, let mime):
            multipart.append(data, withName: key, fileName: fileName ?? UUID().uuidString, mimeType: mime ?? "application/octet-stream")
        case .array(let value):
            throw HTTPMultipartRequestEncoderError.arrayIsForbidden(key: key, value: value)
        case .dictionary(let value):
            throw HTTPMultipartRequestEncoderError.dictionaryIsForbidden(key: key, value: value)
        }
    }
    
    func insertInto(multipart: MultipartFormData) throws {
        switch self {
        case .int64, .int32, .bool, .double, .string, .array, .file, .data:
            throw HTTPMultipartRequestEncoderError.missingParameterKey(parameter: self)
        case .dictionary(let value):
            try value.forEach({ (pair) in
                try pair.value.insertInto(multipart: multipart, key: pair.key)
            })
        }
    }
}

public struct HTTPMultipartRequestEncoder: HTTPRequestEncoder {
    public static let shared = HTTPMultipartRequestEncoder()
    
    public func encode(_ request: Request) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        let formData = MultipartFormData()
        var headers = request.configuration.headers
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = formData.contentType
        }
        let getData = { () throws -> Data? in
            guard let parameter = request.content else {
                return nil
            }
            try parameter.insertInto(multipart: formData)
            let data = try formData.encode()
            return data
        }
        return HTTPBaseRequest(method: request.method, url: url, headers: headers, body: getData)
    }
}

fileprivate extension RequestContent {
    mutating func removeShallowly(key: String) {
        guard case .dictionary(var value) = self else {
            return
        }
        var copy = value
        copy.removeValue(forKey: key)
        self = .dictionary(value: copy)
    }
}

public struct HTTPCombinatedQueryRequestEncoder: HTTPRequestEncoder {

    public let encoderImpl: HTTPRequestEncoder
    public let urlParamKeys: [String]
    
    public init(urlParamKeys: [String], encoderImpl: HTTPRequestEncoder) {
        self.urlParamKeys = urlParamKeys
        self.encoderImpl = encoderImpl
    }
    
    public func encode(_ request: Request) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        
        guard var content = request.content else {
            return try self.encoderImpl.encode(request)
        }
        
        let encodedURL = try url.appendQuery(pairs: queryItems(rootContent: content).filter({ (param) -> Bool in
            return urlParamKeys.contains(param.0)
        }))
        
        urlParamKeys.forEach { (key) in
            content.removeShallowly(key: key)
        }
        let washedReq = PlainRequest(method: request.method, uri: encodedURL.relativeString, configuration: request.configuration, content: content)
        return try self.encoderImpl.encode(washedReq)
    }
}

public enum HTTPSingleBodyRequestEncoderError: HIError {
    case noSuchParameter(key: String)
    case unsupportedInt64(key: String, value: Int64)
    case unsupportedInt32(key: String, value: Int32)
    case unsupportedBool(key: String, value: Bool)
    case unsupportedIntDouble(key: String, value: Double)
    case unsupportedIntString(key: String, value: String)
    case arrayIsForbidden(key: String, value: [RequestContent])
    case dictionaryIsForbidden(key: String, value: [String: RequestContent])
    
    public var errorDescription: String? {
        get {
            switch self {
            case .noSuchParameter(let key):
                return "single body request encoder error: 没有此参数, key : \(key)"
            case .unsupportedInt64(let key, let value):
                return "single body request encoder error: 不支持的Int64, key : \(key), value: \(value)"
            case .unsupportedInt32(let key, let value):
                return "single body request encoder error: 不支持的Int32, key : \(key), value: \(value)"
            case .unsupportedBool(let key, let value):
                return "single body request encoder error: 不支持的Bool, key : \(key), value: \(value)"
            case .unsupportedIntDouble(let key, let value):
                return "single body request encoder error: 不支持的Double, key : \(key), value: \(value)"
            case .unsupportedIntString(let key, let value):
                return "single body request encoder error: 不支持的String, key : \(key), value: \(value)"
            case .arrayIsForbidden(let key, let value):
                return "single body request encoder error: 不支持数组类型的参数, key : \(key), value: \(value)"
            case .dictionaryIsForbidden(let key, let value):
                return "single body request encoder error: 不支持字典类型的参数, key : \(key), value: \(value)"
            }
        }
    }
}

private extension RequestContent {
    func valueClosure(key: String) -> () throws -> Data {
        return {
            switch self {
            case .int64(let value):
                guard let data = String(value).data(using: String.Encoding.utf8) else {
                    throw HTTPSingleBodyRequestEncoderError.unsupportedInt64(key: key, value: value)
                }
                return data
            case .int32(let value):
                guard let data = String(value).data(using: String.Encoding.utf8) else {
                    throw HTTPSingleBodyRequestEncoderError.unsupportedInt32(key: key, value: value)
                }
                return data
            case .bool(let value):
                guard let data = String(value).data(using: String.Encoding.utf8) else {
                    throw HTTPSingleBodyRequestEncoderError.unsupportedBool(key: key, value: value)
                }
                return data
            case .double(let value):
                guard let data = String(value).data(using: String.Encoding.utf8) else {
                    throw HTTPSingleBodyRequestEncoderError.unsupportedIntDouble(key: key, value: value)
                }
                return data
            case .string(let value):
                guard let data = value.data(using: String.Encoding.utf8) else {
                    throw HTTPSingleBodyRequestEncoderError.unsupportedIntString(key: key, value: value)
                }
                return data
            case .file(let url, _, _):
                return try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
            case .data(let data, _, _):
                return data
            case .array(let value):
                throw HTTPSingleBodyRequestEncoderError.arrayIsForbidden(key: key, value: value)
            case .dictionary(let value):
                throw HTTPSingleBodyRequestEncoderError.dictionaryIsForbidden(key: key, value: value)
            }
        }
    }
}

fileprivate extension RequestContent {
    
    func pickShallowly(key: String) -> RequestContent? {
        guard case .dictionary(let value) = self else {
            return nil
        }
        return value[key]
    }
}

public struct HTTPSingleBodyRequestEncoder: HTTPRequestEncoder {
    
    public let urlParamKeys: [String]
    public let singleBodyKey: String
    
    public init(urlParamKeys: [String], singleBodyKey: String) {
        self.urlParamKeys = urlParamKeys
        self.singleBodyKey = singleBodyKey
    }
    
    public func encode(_ request: Request) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        
        guard let content = request.content else {
            return HTTPBaseRequest(method: request.method, url: url, headers: request.configuration.headers, body: { nil } )
        }
        
        let encodedURL = try url.appendQuery(pairs: queryItems(rootContent: content).filter({ (param) -> Bool in
            return urlParamKeys.contains(param.0)
        }))
        
        guard let singleBody = content.pickShallowly(key: singleBodyKey) else {
            throw HTTPSingleBodyRequestEncoderError.noSuchParameter(key: self.singleBodyKey)
        }
        
        var headers = request.configuration.headers
        if headers["Content-Type"] == nil {
            switch singleBody {
            case .file(_, _, let mime):
                headers["Content-Type"] = mime
            case .data(_, _, let mime):
                headers["Content-Type"] = mime
            case .int64, .int32, .bool, .double, .string:
                headers["Content-Type"] = "application/octet-stream"
            case .array(let value):
                throw HTTPSingleBodyRequestEncoderError.arrayIsForbidden(key: singleBodyKey, value: value)
            case .dictionary(let value):
                throw HTTPSingleBodyRequestEncoderError.dictionaryIsForbidden(key: singleBodyKey, value: value)
            }
        }
        return HTTPBaseRequest(method: request.method, url: encodedURL, headers: headers, body: singleBody.valueClosure(key: singleBodyKey))
    }
}

public struct HTTPURLEncodedFormRequestEncoder: HTTPRequestEncoder {
    public static let shared = HTTPURLEncodedFormRequestEncoder()
    
    public func encode(_ request: Request) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        
        var headers = request.configuration.headers
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        }

        guard let content = request.content else {
            return HTTPBaseRequest(method: request.method, url: url, headers: headers , body: { () -> Data? in
                return nil
            })
        }
        
        let bodyClosure = { () -> Data? in 
            let query = try queryItems(rootContent: content)
            return query.map({ return "\($0)=\($1)" }).joined(separator: "&").data(using: String.Encoding.utf8)
        }
        
        return HTTPBaseRequest(method: request.method, url: url, headers: headers , body: bodyClosure)
    }
}

public struct HTTPGzipRequestEncoder: HTTPRequestEncoder {
    
    public let encoderImpl: HTTPRequestEncoder
    
    public init(encoder: HTTPRequestEncoder) {
        self.encoderImpl = encoder
    }
    
    public func encode(_ request: Request) throws -> HTTPRequest {
        var httpRequest = try encoderImpl.encode(request)
        var headers = httpRequest.headers
        if headers["Content-Encoding"] == nil {
            headers["Content-Encoding"] = "gzip"
        }
        httpRequest.headers = headers
        let rawBodyClosure = httpRequest.body
        let bodyClosure = { [rawBodyClosure] () -> Data? in
            let body = try rawBodyClosure()
            let gzipData = try body?.gzipped()
            return gzipData
        }
        httpRequest.body = bodyClosure
        return httpRequest
    }
}
