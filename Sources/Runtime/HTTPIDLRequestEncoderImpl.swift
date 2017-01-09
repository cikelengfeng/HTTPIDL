//
//  HTTPIDLRequestEncoderImpl.swift
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
    
    public var errorDescription: String? {
        get {
            switch self {
            case .constructURLFailed(let urlString):
                return "构造URL对象失败，原始url字符串: " + urlString
            case .nestedObjectInURLQuery(let errorSource):
                return "企图在query中加入嵌套的对象: \(errorSource)"
            }
        }
    }
}

private func queryItems(parameters: [HTTPIDLRequestParameter]) throws -> [(String, String)] {
    return try parameters.flatMap { (param) -> [(String, String)] in
        switch param {
        case .int64(let key, let value):
            return [(key, String(value))]
        case .int32(let key, let value):
            return [(key, String(value))]
        case .double(let key, let value):
            return [(key, String(value))]
        case .string(let key, let value):
            return [(key, value)]
        case .file(let key, let url, _, _):
            return [(key, url.absoluteString)]
        case .data(let key, let data, _, _):
            return [(key, String(data: data, encoding: String.Encoding.utf8) ?? "")]
        case .array(let key, let values):
            return try values.map ({ (paramInArray) in
                switch paramInArray {
                case .int64(_, let value):
                    return (key, String(value))
                case .int32(_, let value):
                    return (key, String(value))
                case .double(_, let value):
                    return (key, String(value))
                case .string(_, let value):
                    return (key, value)
                case .file(_, let url, _, _):
                    return (key, url.absoluteString)
                case .data(_, let data, _, _):
                    return (key, String(data: data, encoding: String.Encoding.utf8) ?? "")
                case .array(_, _):
                    throw HTTPBaseRequestEncoderError.nestedObjectInURLQuery(errorSource: values)
                case .dictionary(_, _):
                    throw HTTPBaseRequestEncoderError.nestedObjectInURLQuery(errorSource: values)
                }
            })
        case .dictionary(_, _):
            throw HTTPBaseRequestEncoderError.nestedObjectInURLQuery(errorSource: param)
        }
    }
}

public struct HTTPURLEncodedQueryRequestEncoder: HTTPRequestEncoder {
    
    public static let shared = HTTPURLEncodedQueryRequestEncoder()
    
    public func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        
        let query = try queryItems(parameters: request.parameters)
        
        let encodedURL = url.appendQuery(pairs: query)
        
        return HTTPBaseRequest(method: request.method, url: encodedURL, headers: request.configuration.headers , body: { () -> Data? in
            return nil
        })
    }
}


public enum HTTPJSONRequestEncoderError: HIError {
    case fileIsForbidden(key: String, file: URL)
    case dataIsForbidden(key: String, data: Data)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .fileIsForbidden(let key, _):
                return "json request encoder 不支持文件, 参数的key: " + key
            case .dataIsForbidden(let key, _):
                return "json request encoder 不支持Data, 参数的key: " + key
            }
        }
    }
}

private extension HTTPIDLRequestParameter {
    func json() throws -> (String, Any) {
        switch self {
        case .int64(let key, let value):
            //int64 在json中可能会溢出，所以我们转换成字符串
            return (key, String(value))
        case .int32(let key, let value):
            return (key, value)
        case .double(let key, let value):
            return (key, value)
        case .string(let key, let value):
            return (key, value)
        case .file(let key, let url, _, _):
            throw HTTPJSONRequestEncoderError.fileIsForbidden(key: key, file: url)
        case .data(let key, let data, _, _):
            throw HTTPJSONRequestEncoderError.dataIsForbidden(key: key, data: data)
        case .array(let key, let array):
            return (key, try array.map({ (paramInArray) in
                return try paramInArray.json().1
            }))
        case .dictionary(let key, let dict):
            return (key, try dict.reduce([:], { (soFar, soGood) in
                var result = soFar
                result[soGood.key] = try soGood.value.json().1
                return result
            }))
        }
    }
}

private func json(parameters: [HTTPIDLRequestParameter]) throws -> Any {
    return try parameters.reduce([:], { (soFar, soGood) in
        var result = soFar
        result[soGood.key] = try soGood.json().1
        return result
    })
}

public struct HTTPJSONRequestEncoder: HTTPRequestEncoder {
    
    public static let shared = HTTPJSONRequestEncoder()
    
    public func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        var headers = request.configuration.headers
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = "application/json"
        }
        let getJsonData = { () throws -> Data? in
            guard request.parameters.count != 0 else {
                return nil
            }
            let jsonDict = try json(parameters: request.parameters)
            let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            return data
        }
        return HTTPBaseRequest(method: request.method, url: url, headers: headers, body: getJsonData)
    }
}

public enum HTTPMultipartRequestEncoderError: HIError {
    case unsupportedInt64(key: String, value: Int64)
    case unsupportedInt32(key: String, value: Int32)
    case unsupportedIntDouble(key: String, value: Double)
    case unsupportedIntString(key: String, value: String)
    case arrayIsForbidden(key: String, value: [HTTPIDLRequestParameter])
    case dictionaryIsForbidden(key: String, value: [String: HTTPIDLRequestParameter])
    
    public var errorDescription: String? {
        get {
            switch self {
            case .unsupportedInt64(let key, let value):
                return "multipart request encoder error: 不支持的Int64, key : \(key), value: \(value)"
            case .unsupportedInt32(let key, let value):
                return "multipart request encoder error: 不支持的Int32, key : \(key), value: \(value)"
            case .unsupportedIntDouble(let key, let value):
                return "multipart request encoder error: 不支持的Double, key : \(key), value: \(value)"
            case .unsupportedIntString(let key, let value):
                return "multipart request encoder error: 不支持的String, key : \(key), value: \(value)"
            case .arrayIsForbidden(let key, let value):
                return "multipart request encoder error: 不支持数组类型的参数, key : \(key), value: \(value)"
            case .dictionaryIsForbidden(let key, let value):
                return "multipart request encoder error: 不支持字典类型的参数, key : \(key), value: \(value)"
            }
        }
    }
}

fileprivate extension MultipartFormData {
    func append(parameter: HTTPIDLRequestParameter) throws {
        switch parameter {
            case .int64(let key, let value):
                guard let data = String(value).data(using: String.Encoding.utf8) else {
                    throw HTTPMultipartRequestEncoderError.unsupportedInt64(key: key, value: value)
                }
                append(data, withName: key)
            case .int32(let key, let value):
                guard let data = String(value).data(using: String.Encoding.utf8) else {
                    throw HTTPMultipartRequestEncoderError.unsupportedInt32(key: key, value: value)
                }
                append(data, withName: key)
            case .double(let key, let value):
                guard let data = String(value).data(using: String.Encoding.utf8) else {
                    throw HTTPMultipartRequestEncoderError.unsupportedIntDouble(key: key, value: value)
                }
                append(data, withName: key)
            case .string(let key, let value):
                guard let data = value.data(using: String.Encoding.utf8) else {
                    throw HTTPMultipartRequestEncoderError.unsupportedIntString(key: key, value: value)
                }
                append(data, withName: key)
            case .file(let key, let url, let fileName, let mime):
                append(url, withName: key, fileName: fileName ?? UUID().uuidString, mimeType: mime ?? "application/octet-stream")
            case .data(let key, let data, let fileName, let mime):
                append(data, withName: key, fileName: fileName ?? UUID().uuidString, mimeType: mime ?? "application/octet-stream")
            case .array(let key, let value):
                throw HTTPMultipartRequestEncoderError.arrayIsForbidden(key: key, value: value)
            case .dictionary(let key, let value):
                throw HTTPMultipartRequestEncoderError.dictionaryIsForbidden(key: key, value: value)
        }
    }
}

public struct HTTPMultipartRequestEncoder: HTTPRequestEncoder {
    public static let shared = HTTPMultipartRequestEncoder()
    
    public func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        let formData = MultipartFormData()
        var headers = request.configuration.headers
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = formData.contentType
        }
        let getData = { () throws -> Data? in
            let encodedMultipart = try request.parameters.reduce(formData, { (soFar, soGood) -> MultipartFormData in
                try soFar.append(parameter: soGood)
                return soFar
            })
            
            
            let data = try encodedMultipart.encode()
            return data
        }
        return HTTPBaseRequest(method: request.method, url: url, headers: headers, body: getData)
    }
}

public struct HTTPCombinatedQueryRequestEncoder: HTTPRequestEncoder {

    public let encoderImpl: HTTPRequestEncoder
    public let urlParamKeys: [String]
    
    public init(urlParamKeys: [String], encoderImpl: HTTPRequestEncoder) {
        self.urlParamKeys = urlParamKeys
        self.encoderImpl = encoderImpl
    }
    
    public func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        
        let encodedURL = try url.appendQuery(pairs: queryItems(parameters: request.parameters.filter({ (param) -> Bool in
            return urlParamKeys.contains(param.key)
        })))
        let washedReq = HTTPIDLPlainRequest(method: request.method, uri: encodedURL.relativeString, configuration: request.configuration, parameters: request.parameters.filter({ (param) -> Bool in
            return !urlParamKeys.contains(param.key)
        }))
        return try self.encoderImpl.encode(washedReq)
    }
}

public enum HTTPSingleBodyRequestEncoderError: HIError {
    case noSuchParameter(key: String)
    case unsupportedInt64(key: String, value: Int64)
    case unsupportedInt32(key: String, value: Int32)
    case unsupportedIntDouble(key: String, value: Double)
    case unsupportedIntString(key: String, value: String)
    case arrayIsForbidden(key: String, value: [HTTPIDLRequestParameter])
    case dictionaryIsForbidden(key: String, value: [String: HTTPIDLRequestParameter])
    
    public var errorDescription: String? {
        get {
            switch self {
            case .noSuchParameter(let key):
                return "single body request encoder error: 没有此参数, key : \(key)"
            case .unsupportedInt64(let key, let value):
                return "single body request encoder error: 不支持的Int64, key : \(key), value: \(value)"
            case .unsupportedInt32(let key, let value):
                return "single body request encoder error: 不支持的Int32, key : \(key), value: \(value)"
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

private extension HTTPIDLRequestParameter {
    var valueClosure: () throws -> Data {
        get {
            return {
                switch self {
                case .int64(let key, let value):
                    guard let data = String(value).data(using: String.Encoding.utf8) else {
                        throw HTTPSingleBodyRequestEncoderError.unsupportedInt64(key: key, value: value)
                    }
                    return data
                case .int32(let key, let value):
                    guard let data = String(value).data(using: String.Encoding.utf8) else {
                        throw HTTPSingleBodyRequestEncoderError.unsupportedInt32(key: key, value: value)
                    }
                    return data
                case .double(let key, let value):
                    guard let data = String(value).data(using: String.Encoding.utf8) else {
                        throw HTTPSingleBodyRequestEncoderError.unsupportedIntDouble(key: key, value: value)
                    }
                    return data
                case .string(let key, let value):
                    guard let data = value.data(using: String.Encoding.utf8) else {
                        throw HTTPSingleBodyRequestEncoderError.unsupportedIntString(key: key, value: value)
                    }
                    return data
                case .file(_, let url, _, _):
                    return try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                case .data(_, let data, _, _):
                    return data
                case .array(let key, let value):
                    throw HTTPSingleBodyRequestEncoderError.arrayIsForbidden(key: key, value: value)
                case .dictionary(let key, let value):
                    throw HTTPSingleBodyRequestEncoderError.dictionaryIsForbidden(key: key, value: value)
                }
            }
        }
    }
}

public struct HTTPSingleBodyRequestEncoder: HTTPRequestEncoder {
    
    public let urlParamKeys: [String]
    public let singleBodyKey: String
    
    public init(urlParamKeys: [String], singleBodyKey: String) {
        self.urlParamKeys = urlParamKeys
        self.singleBodyKey = singleBodyKey
    }
    
    public func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        
        let encodedURL = try url.appendQuery(pairs: queryItems(parameters: request.parameters.filter({ (param) -> Bool in
            return urlParamKeys.contains(param.key)
        })))
        
        guard let singleBody = (request.parameters.first { (param) -> Bool in
            return param.key == self.singleBodyKey
        }) else {
            throw HTTPSingleBodyRequestEncoderError.noSuchParameter(key: self.singleBodyKey)
        }
        
        var headers = request.configuration.headers
        if headers["Content-Type"] == nil {
            switch singleBody {
            case .file(_, _, _, let mime):
                headers["Content-Type"] = mime
            case .data(_, _, _, let mime):
                headers["Content-Type"] = mime
            default:
                headers["Content-Type"] = "application/octet-stream"
            }
        }
        return HTTPBaseRequest(method: request.method, url: encodedURL, headers: headers, body: singleBody.valueClosure)
    }
}

public struct HTTPURLEncodedFormRequestEncoder: HTTPRequestEncoder {
    public static let shared = HTTPURLEncodedFormRequestEncoder()
    
    public func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        
        var headers = request.configuration.headers
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        }

        let bodyClosure = { () -> Data? in 
            let query = try queryItems(parameters: request.parameters)
            return query.map({ return "\($0)=\($1)" }).joined(separator: "&").data(using: String.Encoding.utf8)
        }
        
        return HTTPBaseRequest(method: request.method, url: url, headers: request.configuration.headers , body: bodyClosure)
    }
}

public struct HTTPGzipRequestEncoder: HTTPRequestEncoder {
    
    public let encoderImpl: HTTPRequestEncoder
    
    public init(encoder: HTTPRequestEncoder) {
        self.encoderImpl = encoder
    }
    
    public func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
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
