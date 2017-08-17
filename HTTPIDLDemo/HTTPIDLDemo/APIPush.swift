//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL

class PutPushTokenRequest: Request {
    
    var method: String = "PUT"
    private var _configuration: RequestConfiguration?
    var configuration: RequestConfiguration {
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
    var manager: RequestManager = BaseRequestManager.shared
    var uri: String {
        return "/push/token"
    }
    
    var token: String?
    var channel: String?
    
    let keyOfToken = "token"
    let keyOfChannel = "channel"
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = token {
            result["token"] = tmp.asRequestContent()
        }
        if let tmp = channel {
            result["channel"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PutPushTokenResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PutPushTokenResponse> {
        let future: RequestFuture<PutPushTokenResponse> = manager.send(self)
        future.responseHandler = completion
        future.errorHandler = errorHandler
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = manager.send(self)
        future.responseHandler = rawResponseHandler
        future.errorHandler = errorHandler
        return future
    }
}

class DeletePushTokenRequest: Request {
    
    var method: String = "DELETE"
    private var _configuration: RequestConfiguration?
    var configuration: RequestConfiguration {
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
    var manager: RequestManager = BaseRequestManager.shared
    var uri: String {
        return "/push/token"
    }
    
    
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (DeletePushTokenResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<DeletePushTokenResponse> {
        let future: RequestFuture<DeletePushTokenResponse> = manager.send(self)
        future.responseHandler = completion
        future.errorHandler = errorHandler
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = manager.send(self)
        future.responseHandler = rawResponseHandler
        future.errorHandler = errorHandler
        return future
    }
}

struct PutPushTokenResponse: Response {
    
    let code: Int32?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            return
        }
        self.code = Int32(content: value["code"])
    }
}

struct DeletePushTokenResponse: Response {
    
    let code: Int32?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            return
        }
        self.code = Int32(content: value["code"])
    }
}
