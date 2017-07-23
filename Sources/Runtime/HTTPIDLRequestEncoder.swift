//
//  RequestEncoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30//

import Foundation
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
    case .number(let value):
        return [(key, value.stringValue)]
    case .string(let value):
        return [(key, value)]
    case .file(let url, _, _):
        return [(key, url.absoluteString)]
    case .data(let data, _, _):
        return [(key, String(data: data, encoding: String.Encoding.utf8) ?? "")]
    case .array(let values):
        return try values.flatMap ({ (contentInArray) -> [(String, String)] in
            switch contentInArray {
            case .number, .string, .file, .data:
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
    case .number, .string, .array, .file, .data:
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
            return HTTPBaseRequest(method: request.method, url: url, headers: request.configuration.headers , bodyStream: nil)
        }
        let query = try queryItems(rootContent: content)
        
        let encodedURL = url.appendQuery(pairs: query)
        
        return HTTPBaseRequest(method: request.method, url: encodedURL, headers: request.configuration.headers , bodyStream: nil)
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
        guard let rootParameter = request.content else {
            return HTTPBaseRequest(method: request.method, url: url, headers: headers, bodyStream: nil)
        }
        let jsonDict = try rootParameter.jsonObject()
        let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
        let stream = InputStream(data: data)
        return HTTPBaseRequest(method: request.method, url: url, headers: headers, bodyStream: stream)
    }
}

public enum HTTPMultipartRequestEncoderError: HIError {
    case unsupportedNumber(key: String, value: NSNumber)
    case unsupportedString(key: String, value: String)
    case arrayIsForbidden(key: String, value: [RequestContent])
    case dictionaryIsForbidden(key: String, value: [String: RequestContent])
    case missingParameterKey(parameter: RequestContent)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .unsupportedNumber(let key, let value):
                return "multipart request encoder error: 不支持的数字, key : \(key), value: \(value)"
            case .unsupportedString(let key, let value):
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
        case .number(let value):
            guard let data = value.stringValue.data(using: String.Encoding.utf8) else {
                throw HTTPMultipartRequestEncoderError.unsupportedNumber(key: key, value: value)
            }
            multipart.append(data, withName: key)
        case .string(let value):
            guard let data = value.data(using: String.Encoding.utf8) else {
                throw HTTPMultipartRequestEncoderError.unsupportedString(key: key, value: value)
            }
            multipart.append(data, withName: key)
        case .file(let url, let fileName, let mime):
            multipart.append(url, withName: key, fileName: fileName ?? UUID().uuidString, mimeType: mime ?? "application/octet-stream")
        case .data(let data, let fileName, let mime):
            multipart.append(data, withName: key, fileName: fileName ?? UUID().uuidString, mimeType: mime ?? "application/octet-stream")
        case .array(let value):
            try value.forEach({ (content) in
                try content.insertInto(multipart: multipart, key: key)
            })
        case .dictionary(let value):
            throw HTTPMultipartRequestEncoderError.dictionaryIsForbidden(key: key, value: value)
        }
    }
    
    func insertInto(multipart: MultipartFormData) throws {
        switch self {
        case .number, .string, .array, .file, .data:
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
        guard let parameter = request.content else {
            return HTTPBaseRequest(method: request.method, url: url, headers: headers, bodyStream: nil)
        }
        try parameter.insertInto(multipart: formData)
        let stream = formData.stream()
        return HTTPBaseRequest(method: request.method, url: url, headers: headers, bodyStream: stream)
    }
}

fileprivate extension RequestContent {
    mutating func removeShallowly(key: String) {
        guard case .dictionary(let value) = self else {
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
    case unsupportedNumber(key: String, value: NSNumber)
    case unsupportedString(key: String, value: String)
    case arrayIsForbidden(key: String, value: [RequestContent])
    case dictionaryIsForbidden(key: String, value: [String: RequestContent])
    
    public var errorDescription: String? {
        get {
            switch self {
            case .noSuchParameter(let key):
                return "single body request encoder error: 没有此参数, key : \(key)"
            case .unsupportedNumber(let key, let value):
                return "single body request encoder error: 不支持的数字, key : \(key), value: \(value)"
            case .unsupportedString(let key, let value):
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
    func dataStream(key: String) throws -> InputStream? {
        switch self {
        case .number(let value):
            guard let data = value.stringValue.data(using: String.Encoding.utf8) else {
                throw HTTPSingleBodyRequestEncoderError.unsupportedNumber(key: key, value: value)
            }
            return InputStream(data: data)
        case .string(let value):
            guard let data = value.data(using: String.Encoding.utf8) else {
                throw HTTPSingleBodyRequestEncoderError.unsupportedString(key: key, value: value)
            }
            return InputStream(data: data)
        case .file(let url, _, _):
            return InputStream(fileAtPath: url.absoluteString)
        case .data(let data, _, _):
            return InputStream(data: data)
        case .array(let value):
            throw HTTPSingleBodyRequestEncoderError.arrayIsForbidden(key: key, value: value)
        case .dictionary(let value):
            throw HTTPSingleBodyRequestEncoderError.dictionaryIsForbidden(key: key, value: value)
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
            return HTTPBaseRequest(method: request.method, url: url, headers: request.configuration.headers, bodyStream: nil)
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
            case .number, .string:
                headers["Content-Type"] = "application/octet-stream"
            case .array(let value):
                throw HTTPSingleBodyRequestEncoderError.arrayIsForbidden(key: singleBodyKey, value: value)
            case .dictionary(let value):
                throw HTTPSingleBodyRequestEncoderError.dictionaryIsForbidden(key: singleBodyKey, value: value)
            }
        }
        let stream = try singleBody.dataStream(key: singleBodyKey)
        return HTTPBaseRequest(method: request.method, url: encodedURL, headers: headers, bodyStream: stream)
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
            return HTTPBaseRequest(method: request.method, url: url, headers: headers , bodyStream: nil)
        }
        
        let query = try queryItems(rootContent: content)
        guard let data = query.map({ return "\($0)=\($1)" }).joined(separator: "&").data(using: String.Encoding.utf8) else {
            return HTTPBaseRequest(method: request.method, url: url, headers: headers, bodyStream: nil)
        }
        let stream = InputStream(data: data)
        
        return HTTPBaseRequest(method: request.method, url: url, headers: headers , bodyStream: stream)
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
        let rawBody = httpRequest.bodyStream?.data()
        let gzipData = try rawBody?.gzipped()
        if let gzData = gzipData {
            httpRequest.bodyStream = InputStream(data: gzData)
        }
        return httpRequest
    }
}

public enum HTTPBinaryRequestEncoderError: HIError {
    case invalidType
    
    public var errorDescription: String? {
        switch self {
        case .invalidType:
            return "binary encoder only support file & data"
        }
    }
}

public struct HTTPBinaryRequestEncoder: HTTPRequestEncoder {
    
    public static let shared = HTTPBinaryRequestEncoder()
    
    public func encode(_ request: Request) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configuration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed(urlString: request.configuration.baseURLString + request.uri)
        }
        
        var headers = request.configuration.headers
        guard let content = request.content else {
            return HTTPBaseRequest(method: request.method, url: url, headers: headers , bodyStream: nil)
        }
        
        var stream: InputStream?
        switch content {
        case .file(let url, _, let mimeType):
            if headers["Content-Type"] == nil {
                headers["Content-Type"] = mimeType
            }
            stream = InputStream(url: url)
        case .data(let value, _, let mimeType):
            if headers["Content-Type"] == nil {
                headers["Content-Type"] = mimeType
            }
            stream = InputStream(data: value)
        case .number, .string, .array, .dictionary:
            throw HTTPBinaryRequestEncoderError.invalidType
        }
        
        return HTTPBaseRequest(method: request.method, url: url, headers: headers , bodyStream: stream)
    }
}
