//
//  RequestHelper.swift
//  Pods
//
//  Created by 徐 东 on 2019/4/3.
//

import Foundation

public class SimpleRequest: Request {
    
    public var method: String = "GET"
    private var _configuration: RequestConfiguration?
    public var configuration: RequestConfiguration {
        get {
            guard let config = _configuration else {
                return BaseRequestConfiguration.create(from: manager.configuration, request: self)
            }
            return config
        }
        set {
            _configuration = newValue
        }
    }
    public var manager: RequestManager = BaseRequestManager.shared
    public private(set) var uri: String
    
    public init(url: URL) {
        self.uri = url.relativeString
        self.configuration.baseURLString = url.baseURL?.absoluteString ?? ""
    }
    
    public var content: RequestContent?
}

public struct SimpleStringResponse: Response {
    
    public let body: String?
    public let rawResponse: HTTPResponse
    public init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = String(content: content)
    }
}

public struct SimpleJSONResponse: Response {
    
    public let body: Any?
    public let rawResponse: HTTPResponse
    public init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        let jsonObject = JSONObject(content: content)
        self.body = jsonObject?.json
    }
}

@discardableResult
public func get(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleStringResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleStringResponse> {
    return send(method: "GET", url: url, params: params, encoder: URLEncodedQueryEncoder.shared, decoder: UTF8StringDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func getJSON(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleJSONResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleJSONResponse> {
    return send(method: "GET", url: url, params: params, encoder: URLEncodedQueryEncoder.shared, decoder: JSONDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func post(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleStringResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleStringResponse> {
    return send(method: "POST", url: url, params: params, encoder: URLEncodedFormEncoder.shared, decoder: UTF8StringDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func postJSON(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleJSONResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleJSONResponse> {
    return send(method: "POST", url: url, params: params, encoder: URLEncodedFormEncoder.shared, decoder: JSONDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func put(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleStringResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleStringResponse> {
    return send(method: "PUT", url: url, params: params, encoder: URLEncodedFormEncoder.shared, decoder: UTF8StringDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func putJSON(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleJSONResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleJSONResponse> {
    return send(method: "PUT", url: url, params: params, encoder: URLEncodedFormEncoder.shared, decoder: JSONDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func patch(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleStringResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleStringResponse> {
    return send(method: "PATCH", url: url, params: params, encoder: URLEncodedFormEncoder.shared, decoder: UTF8StringDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func patchJSON(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleJSONResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleJSONResponse> {
    return send(method: "PATCH", url: url, params: params, encoder: URLEncodedFormEncoder.shared, decoder: JSONDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func delete(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleStringResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleStringResponse> {
    return send(method: "DELETE", url: url, params: params, encoder: URLEncodedFormEncoder.shared, decoder: UTF8StringDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func deleteJSON(url: URL, params: RequestContentConvertible, completion: @escaping (SimpleJSONResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<SimpleJSONResponse> {
    return send(method: "DELETE", url: url, params: params, encoder: URLEncodedFormEncoder.shared, decoder: JSONDecoder(), completion: completion, errorHandler: errorHandler)
}

@discardableResult
public func send<T: Response>(method: String, url: URL, params: RequestContentConvertible, encoder: Encoder, decoder: Decoder, completion: @escaping (T) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<T> {
    let request = SimpleRequest(url: url)
    request.method = method
    request.content = params.asRequestContent()
    request.configuration.encoder = encoder
    request.configuration.decoder = decoder
    let future: RequestFuture<T> = request.manager.send(request, responseHandler: completion, errorHandler: errorHandler, progressHandler: nil)
    return future
}
