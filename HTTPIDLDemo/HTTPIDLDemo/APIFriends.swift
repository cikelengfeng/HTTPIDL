//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL

struct SuggestionsWrapper {
    
    var contents: [SuggestionStruct]?
}

extension SuggestionsWrapper: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        if let content = value["suggestions"] {
            let contents = [SuggestionStruct](content: content)
            self.contents = contents
        } else {
            self.contents = nil
        }
    }
}

struct SuggestionStruct {
    
    var id: Int64?
    var name: String?
    var avatarUrl: String?
    var snapsCount: Int32?
    var reason: String?
}

extension SuggestionStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.id = Int64(content: value["user_id"])
        self.name = String(content: value["name"])
        self.avatarUrl = String(content: value["avatar_url"])
        self.snapsCount = Int32(content: value["snaps_count"])
        self.reason = String(content: value["reason"])
    }
}

struct UsersWrapper {
    
    var contents: [UserStruct]?
}

extension UsersWrapper: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        if let content = value["users"] {
            let contents = [UserStruct](content: content)
            self.contents = contents
        } else {
            self.contents = nil
        }
    }
}

class PostConnectionsFollowRequest: Request {
    
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
        return "/connections/follow"
    }
    
    var userId: [String]?
    
    let keyOfUserId = "user_id"
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = userId {
            let tmp = tmp.asRequestContent()
            result["user_id"] = tmp
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PostConnectionsFollowResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostConnectionsFollowResponse> {
        let future: RequestFuture<PostConnectionsFollowResponse> = client.send(self)
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

struct PostConnectionsFollowResponse: Response {
    
    let code: Int32?
    let userId: Int64?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.userId = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.userId = Int64(content: value["user_id"])
    }
}

class GetConnectionsFollowingRequest: Request {
    
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
        return "/connections/following"
    }
    
    var page: String?
    var count: Int32?
    
    let keyOfPage = "p"
    let keyOfCount = "count"
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = page {
            result["p"] = tmp.asRequestContent()
        }
        if let tmp = count {
            result["count"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetConnectionsFollowingResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetConnectionsFollowingResponse> {
        let future: RequestFuture<GetConnectionsFollowingResponse> = client.send(self)
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

struct GetConnectionsFollowingResponse: Response {
    
    let code: Int32?
    let pagination: PaginationStruct?
    let users: UsersWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.pagination = nil
            self.users = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.pagination = PaginationStruct(content: value["pagination"])
        self.users = UsersWrapper(content: value["data"])
    }
}

class DeleteConnectionsUserIdRequest: Request {
    
    let user_id: String
    var method: String = "DELETE"
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
        return "/connections/\(user_id)"
    }
    
    var userId: Int64?
    
    let keyOfUserId = "user_id"
    
    init(user_id: String) {
        self.user_id = user_id
    }
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = userId {
            result["user_id"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (DeleteConnectionsUserIdResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<DeleteConnectionsUserIdResponse> {
        let future: RequestFuture<DeleteConnectionsUserIdResponse> = client.send(self)
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

struct DeleteConnectionsUserIdResponse: Response {
    
    let code: Int32?
    let userId: Int64?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.userId = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.userId = Int64(content: value["user_id"])
    }
}

class GetConnectionsNewFollowersRequest: Request {
    
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
        return "/connections/new_followers"
    }
    
    
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (GetConnectionsNewFollowersResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetConnectionsNewFollowersResponse> {
        let future: RequestFuture<GetConnectionsNewFollowersResponse> = client.send(self)
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

class DeleteConnectionsNewFollowersRequest: Request {
    
    var method: String = "DELETE"
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
        return "/connections/new_followers"
    }
    
    
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (DeleteConnectionsNewFollowersResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<DeleteConnectionsNewFollowersResponse> {
        let future: RequestFuture<DeleteConnectionsNewFollowersResponse> = client.send(self)
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

struct GetConnectionsNewFollowersResponse: Response {
    
    let code: Int32?
    let userId: Int64?
    let users: UsersWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.userId = nil
            self.users = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.userId = Int64(content: value["user_id"])
        self.users = UsersWrapper(content: value["data"])
    }
}

struct DeleteConnectionsNewFollowersResponse: Response {
    
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

class GetConnectionsSuggestionsRequest: Request {
    
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
        return "/connections/suggestions"
    }
    
    
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (GetConnectionsSuggestionsResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetConnectionsSuggestionsResponse> {
        let future: RequestFuture<GetConnectionsSuggestionsResponse> = client.send(self)
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

struct GetConnectionsSuggestionsResponse: Response {
    
    let code: Int32?
    let users: SuggestionsWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.users = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.users = SuggestionsWrapper(content: value["data"])
    }
}

class GetConnectionsFollowersRequest: Request {
    
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
        return "/connections/followers"
    }
    
    var page: String?
    var count: Int32?
    
    let keyOfPage = "p"
    let keyOfCount = "count"
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = page {
            result["p"] = tmp.asRequestContent()
        }
        if let tmp = count {
            result["count"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetConnectionsFollowersResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetConnectionsFollowersResponse> {
        let future: RequestFuture<GetConnectionsFollowersResponse> = client.send(self)
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

struct GetConnectionsFollowersResponse: Response {
    
    let code: Int32?
    let pagination: PaginationStruct?
    let users: UsersWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.pagination = nil
            self.users = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.pagination = PaginationStruct(content: value["pagination"])
        self.users = UsersWrapper(content: value["data"])
    }
}
