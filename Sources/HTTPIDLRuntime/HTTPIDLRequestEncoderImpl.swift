//
//  HTTPIDLRequestEncoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPBaseRequestEncoderError: Error {
    case constructURLFailed
}

struct HTTPBaseRequestEncoder: HTTPRequestEncoder {
    
    static let shared = HTTPBaseRequestEncoder()
    
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed
        }
        
        let encodedURL = try url.appendQuery(pairs: request.parameters.map({ (param) -> (String, String) in
            let value = String(data: try param.value(), encoding: String.Encoding.utf8)
            return (param.key, value ?? "")
        }))
        return HTTPBaseRequest(method: request.method, url: encodedURL, headers: request.configration.headers , body: { () -> Data? in
            return nil
        })
    }
}

struct HTTPJSONRequestEncoder: HTTPRequestEncoder {
    
    static let shared = HTTPJSONRequestEncoder()
    
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed
        }
        var headers = request.configration.headers
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = "application/json"
        }
        let getJsonData = { () throws -> Data? in
            guard request.parameters.count != 0 else {
                return nil
            }
            let jsonDict = try request.parameters.reduce([String: String]()) { (soFar, soGood) in
                var ret = soFar
                let value = String(data: try soGood.value(), encoding: String.Encoding.utf8)
                ret[soGood.key] = value ?? ""
                return ret
            }
            let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            return data
        }
        return HTTPBaseRequest(method: request.method, url: url, headers: headers, body: getJsonData)
    }
}

struct HTTPMultipartRequestEncoder: HTTPRequestEncoder {
    static let shared = HTTPMultipartRequestEncoder()
    
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed
        }
        let formData = MultipartFormData()
        var headers = request.configration.headers
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = formData.contentType
        }
        let getData = { () throws -> Data? in
            let encodedMultipart = try request.parameters.reduce(formData, { (soFar, soGood) -> MultipartFormData in
                let value = try soGood.value()
                if let fileName = soGood.fileName, let mime = soGood.mimeType {
                    soFar.append(value, withName: soGood.key, fileName: fileName, mimeType: mime)
                } else if let mime = soGood.mimeType {
                    soFar.append(value, withName: soGood.key, mimeType: mime)
                } else if let fileName = soGood.fileName {
                    soFar.append(value, withName: soGood.key, fileName: fileName, mimeType: "application/octet-stream")
                } else {
                    soFar.append(value, withName: soGood.key)
                }
                return soFar
            })
            
            
            let data = try encodedMultipart.encode()
            return data
        }
        return HTTPBaseRequest(method: request.method, url: url, headers: headers, body: getData)
    }
}

private struct HTTPIDLPlainRequest: HTTPIDLRequest {
    var method: String
    var configration: HTTPIDLConfiguration
    var uri: String
    var parameters: [HTTPIDLParameter]
    
    init(method: String, uri: String, configration: HTTPIDLConfiguration, parameters: [HTTPIDLParameter]) {
        self.method = method
        self.configration = configration
        self.uri = uri
        self.parameters = parameters
    }
}

struct HTTPCombinatedRequestEncoder: HTTPRequestEncoder {

    let encoderImpl: HTTPRequestEncoder
    let urlParamKeys: [String]
    
    init(urlParamKeys: [String], encoderImpl: HTTPRequestEncoder) {
        self.urlParamKeys = urlParamKeys
        self.encoderImpl = encoderImpl
    }
    
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed
        }
        
        let encodedURL = try url.appendQuery(pairs: request.parameters.filter({ (param) -> Bool in
            return urlParamKeys.contains(param.key)
        }).map({ (param) -> (String, String) in
            let value = String(data: try param.value(), encoding: String.Encoding.utf8)
            return (param.key, value ?? "")
        }))
        let washedReq = HTTPIDLPlainRequest(method: request.method, uri: encodedURL.relativeString, configration: request.configration, parameters: request.parameters.filter({ (param) -> Bool in
            return !urlParamKeys.contains(param.key)
        }))
        return try self.encoderImpl.encode(washedReq)
    }
}

enum HTTPSingleBodyRequestEncoderError: Error {
    case NoSuchParameter
}

struct HTTPSingleBodyRequestEncoder: HTTPRequestEncoder {
    
    let urlParamKeys: [String]
    let singleBodyKey: String
    
    init(urlParamKeys: [String], singleBodyKey: String) {
        self.urlParamKeys = urlParamKeys
        self.singleBodyKey = singleBodyKey
    }
    
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        guard let url = URL(string: request.uri, relativeTo: URL(string: request.configration.baseURLString)) else {
            throw HTTPBaseRequestEncoderError.constructURLFailed
        }
        
        let encodedURL = try url.appendQuery(pairs: request.parameters.filter({ (param) -> Bool in
            return urlParamKeys.contains(param.key)
        }).map({ (param) -> (String, String) in
            let value = String(data: try param.value(), encoding: String.Encoding.utf8)
            return (param.key, value ?? "")
        }))
        
        guard let singleBody = (request.parameters.first { (param) -> Bool in
            return param.key == self.singleBodyKey
        }) else {
            throw HTTPSingleBodyRequestEncoderError.NoSuchParameter
        }
        
        var headers = request.configration.headers
        if headers["Content-Type"] == nil, let mime = singleBody.mimeType {
            headers["Content-Type"] = mime
        }
        return HTTPBaseRequest(method: request.method, url: encodedURL, headers: headers, body: singleBody.value)
    }
}
