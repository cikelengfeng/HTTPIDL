//
//  DownloadHelper.swift
//  Pods
//
//  Created by 徐 东 on 2017/7/28.
//
//

import Foundation

public class DownloadRequest: Request {
    
    public var method: String = "GET"
    private var _configuration: RequestConfiguration?
    public var configuration: RequestConfiguration {
        get {
            guard let config = _configuration else {
                return BaseRequestConfiguration.create(from: client.configuration, request: self)
            }
            return config
        }
        set {
            _configuration = newValue
        }
    }
    public var client: Client = BaseClient.shared
    public private(set) var uri: String
    
    public init(url: URL, savePath: String) {
        self.uri = url.relativeString
        self.configuration.baseURLString = url.baseURL?.absoluteString ?? ""
        self.configuration.decoder = HTTPResponseFileDecoder(filePath: savePath)
    }
    
    public private(set) var content: RequestContent?
    
    @discardableResult
    public func send(completion: @escaping (DownloadResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<DownloadResponse> {
        let future: RequestFuture<DownloadResponse> = client.send(self)
        future.responseHandler = completion
        future.errorHandler = errorHandler
        return future
    }
    
}

public struct DownloadResponse: Response {
    
    public let body: HTTPFile?
    public let rawResponse: HTTPResponse
    public init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = HTTPFile(content: content)
    }
}

extension String {
    public func download(toPath savePath: String, completion: @escaping (DownloadResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        let req = downloadRequest(toPath: savePath)
        req.send(completion: completion, errorHandler: errorHandler)
    }
    public func downloadRequest(toPath savePath: String) -> DownloadRequest {
        let url = URL(string: self)!
        return DownloadRequest(url: url, savePath: savePath)
    }
}

extension URL {
    public func download(toPath savePath: String, completion: @escaping (DownloadResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        let req = downloadRequest(toPath: savePath)
        req.send(completion: completion, errorHandler: errorHandler)
    }
    public func downloadRequest(toPath savePath: String) -> DownloadRequest {
        return DownloadRequest(url: self, savePath: savePath)
    }
}
