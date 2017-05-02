//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL

struct ApplicationEvent {
    
    var sessionId: String?
    var eventName: String?
    var timestamp: String?
    var eventId: String?
    var properties: JSONObject?
}

extension ApplicationEvent: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        var result = [String: RequestContent]()
        if let tmp = sessionId {
            result["session_id"] = tmp.asRequestContent()
        }
        if let tmp = eventName {
            result["event"] = tmp.asRequestContent()
        }
        if let tmp = timestamp {
            result["timestamp"] = tmp.asRequestContent()
        }
        if let tmp = eventId {
            result["event_id"] = tmp.asRequestContent()
        }
        if let tmp = properties {
            result["properties"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
}

struct UserStructWrapper {
    
    var content: UserStruct?
}

extension UserStructWrapper: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.content = UserStruct(content: value["user"])
    }
}

struct UserAuthWrappter {
    
    var user: UserStruct?
    var token: String?
}

extension UserAuthWrappter: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.user = UserStruct(content: value["user_profile"])
        self.token = String(content: value["token"])
    }
}

class GetUsersUserIdRequest: Request {
    
    let userId: String
    var method: String = "GET"
    private var _configuration: Configuration?
    var configuration: Configuration {
        get {
            guard let config = _configuration else {
                return client.configuration
            }
            return config
        }
        set {
            _configuration = newValue
        }
    }
    var client: Client = BaseClient.shared
    var uri: String {
        return "/users/\(userId)"
    }
    init(userId: String) {
        self.userId = userId
    }
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (GetUsersUserIdResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetUsersUserIdResponse> {
        let future: RequestFuture<GetUsersUserIdResponse> = client.send(self)
        future.responseHandler = completion
        future.errorHandler = errorHandler
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = client.send(self)
        future.responseHandler = rawResponseHandler
        future.errorHandler = errorHandler
        return future
    }
}

struct GetUsersUserIdResponse: Response {
    
    let code: Int32?
    let user: UserStructWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.user = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.user = UserStructWrapper(content: value["data"])
    }
}

class GetUsersSelfRequest: Request {
    
    var method: String = "GET"
    private var _configuration: Configuration?
    var configuration: Configuration {
        get {
            guard let config = _configuration else {
                return client.configuration
            }
            return config
        }
        set {
            _configuration = newValue
        }
    }
    var client: Client = BaseClient.shared
    var uri: String {
        return "/users/self"
    }
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (GetUsersSelfResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetUsersSelfResponse> {
        let future: RequestFuture<GetUsersSelfResponse> = client.send(self)
        future.responseHandler = completion
        future.errorHandler = errorHandler
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = client.send(self)
        future.responseHandler = rawResponseHandler
        future.errorHandler = errorHandler
        return future
    }
}

struct GetUsersSelfResponse: Response {
    
    let code: Int32?
    let user: UserStructWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.user = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.user = UserStructWrapper(content: value["data"])
    }
}

class PostAuthWeixinRequest: Request {
    
    var method: String = "POST"
    private var _configuration: Configuration?
    var configuration: Configuration {
        get {
            guard let config = _configuration else {
                return client.configuration
            }
            return config
        }
        set {
            _configuration = newValue
        }
    }
    var client: Client = BaseClient.shared
    var uri: String {
        return "/auth/weixin"
    }
    var code: String?
    var appid: String?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = code {
            result["code"] = tmp.asRequestContent()
        }
        if let tmp = appid {
            result["appid"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PostAuthWeixinResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostAuthWeixinResponse> {
        let future: RequestFuture<PostAuthWeixinResponse> = client.send(self)
        future.responseHandler = completion
        future.errorHandler = errorHandler
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = client.send(self)
        future.responseHandler = rawResponseHandler
        future.errorHandler = errorHandler
        return future
    }
}

struct PostAuthWeixinResponse: Response {
    
    let authInfo: UserAuthWrappter?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.authInfo = nil
            return
        }
        self.authInfo = UserAuthWrappter(content: value["data"])
    }
}

class PatchUsersPrivacyLevelRequest: Request {
    
    var method: String = "PATCH"
    private var _configuration: Configuration?
    var configuration: Configuration {
        get {
            guard let config = _configuration else {
                return client.configuration
            }
            return config
        }
        set {
            _configuration = newValue
        }
    }
    var client: Client = BaseClient.shared
    var uri: String {
        return "/users/privacy_level"
    }
    var level: String?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = level {
            result["level"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PatchUsersPrivacyLevelResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PatchUsersPrivacyLevelResponse> {
        let future: RequestFuture<PatchUsersPrivacyLevelResponse> = client.send(self)
        future.responseHandler = completion
        future.errorHandler = errorHandler
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = client.send(self)
        future.responseHandler = rawResponseHandler
        future.errorHandler = errorHandler
        return future
    }
}

struct PatchUsersPrivacyLevelResponse: Response {
    
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

class PostApplicationEventsRequest: Request {
    
    var method: String = "POST"
    private var _configuration: Configuration?
    var configuration: Configuration {
        get {
            guard let config = _configuration else {
                return client.configuration
            }
            return config
        }
        set {
            _configuration = newValue
        }
    }
    var client: Client = BaseClient.shared
    var uri: String {
        return "/application/events"
    }
    var events: [ApplicationEvent]?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = events {
            let tmp = tmp.asRequestContent()
            result["events"] = tmp
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PostApplicationEventsResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostApplicationEventsResponse> {
        let future: RequestFuture<PostApplicationEventsResponse> = client.send(self)
        future.responseHandler = completion
        future.errorHandler = errorHandler
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = client.send(self)
        future.responseHandler = rawResponseHandler
        future.errorHandler = errorHandler
        return future
    }
}

struct PostApplicationEventsResponse: Response {
    
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
