//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL

struct SnapPackageStruct {
    
    var snap: SnapStruct?
    var user: UserStruct?
    var actions: SnapActionsCollectionStruct?
}

extension SnapPackageStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.snap = SnapStruct(content: value["snap"])
        self.user = UserStruct(content: value["user"])
        self.actions = SnapActionsCollectionStruct(content: value["snap_actions"])
    }
}

struct SnapActionsCollectionStruct {
    
    var users: [UserStruct]?
    var actions: [SnapActionStruct]?
}

extension SnapActionsCollectionStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        if let content = value["users"] {
            let users = [UserStruct](content: content)
            self.users = users
        } else {
            self.users = nil
        }
        if let content = value["actions"] {
            let actions = [SnapActionStruct](content: content)
            self.actions = actions
        } else {
            self.actions = nil
        }
    }
}

struct TokensWrapper {
    
    var tokens: [TokenStruct]?
}

extension TokensWrapper: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        if let content = value["tokens"] {
            let tokens = [TokenStruct](content: content)
            self.tokens = tokens
        } else {
            self.tokens = nil
        }
    }
}

struct TokenStruct {
    
    var id: Int64?
    var token: String?
}

extension TokenStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.id = Int64(content: value["id"])
        self.token = String(content: value["token"])
    }
}

struct SnapWrapper {
    
    var content: SnapStruct?
}

extension SnapWrapper: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.content = SnapStruct(content: value["snap"])
    }
}

struct SnapsWrapper {
    
    var contents: [SnapStruct]?
}

extension SnapsWrapper: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        if let content = value["snaps"] {
            let contents = [SnapStruct](content: content)
            self.contents = contents
        } else {
            self.contents = nil
        }
    }
}

struct SnapActionStruct {
    
    var id: Int64?
    var creationDate: String?
    var userId: Int64?
    var type: String?
    var text: String?
}

extension SnapActionStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.id = Int64(content: value["id"])
        self.creationDate = String(content: value["created_at"])
        self.userId = Int64(content: value["user_id"])
        self.type = String(content: value["type"])
        self.text = String(content: value["text"])
    }
}

struct SnapActionWrapper {
    
    var content: SnapActionStruct?
}

extension SnapActionWrapper: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.content = SnapActionStruct(content: value["action"])
    }
}

class GetSnapsRequest: Request {
    
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
        return "/snaps"
    }
    var userId: Int64?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = userId {
            result["user_id"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetSnapsResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetSnapsResponse> {
        let future: RequestFuture<GetSnapsResponse> = client.send(self)
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

class PostSnapsRequest: Request {
    
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
        return "/snaps"
    }
    var file: HTTPFile?
    var data: HTTPData?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = file {
            result["file"] = tmp.asRequestContent()
        }
        if let tmp = data {
            result["file"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PostSnapsResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostSnapsResponse> {
        let future: RequestFuture<PostSnapsResponse> = client.send(self)
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

struct GetSnapsResponse: Response {
    
    let code: Int32?
    let snaps: SnapsWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.snaps = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.snaps = SnapsWrapper(content: value["data"])
    }
}

struct PostSnapsResponse: Response {
    
    let code: Int32?
    let snap: SnapWrapper?
    let message: String?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.snap = nil
            self.message = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.snap = SnapWrapper(content: value["data"])
        self.message = String(content: value["message"])
    }
}

class GetSnapsSelfRequest: Request {
    
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
        return "/snaps/self"
    }
    var page: String?
    var count: Int32?
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
    func send(completion: @escaping (GetSnapsSelfResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetSnapsSelfResponse> {
        let future: RequestFuture<GetSnapsSelfResponse> = client.send(self)
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

struct GetSnapsSelfResponse: Response {
    
    let code: Int32?
    let snaps: SnapsWrapper?
    let pagination: PaginationStruct?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.snaps = nil
            self.pagination = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.snaps = SnapsWrapper(content: value["data"])
        self.pagination = PaginationStruct(content: value["pagination"])
    }
}

class GetSnapsSnapIdRequest: Request {
    
    let snapId: String
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
        return "/snaps/\(snapId)"
    }
    var owner: String?
    init(snapId: String) {
        self.snapId = snapId
    }
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = owner {
            result["owner"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetSnapsSnapIdResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetSnapsSnapIdResponse> {
        let future: RequestFuture<GetSnapsSnapIdResponse> = client.send(self)
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

class DeleteSnapsSnapIdRequest: Request {
    
    let snapId: String
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
        return "/snaps/\(snapId)"
    }
    init(snapId: String) {
        self.snapId = snapId
    }
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (DeleteSnapsSnapIdResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<DeleteSnapsSnapIdResponse> {
        let future: RequestFuture<DeleteSnapsSnapIdResponse> = client.send(self)
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

struct GetSnapsSnapIdResponse: Response {
    
    let code: Int32?
    let snapPackage: SnapPackageStruct?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.snapPackage = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.snapPackage = SnapPackageStruct(content: value["data"])
    }
}

struct DeleteSnapsSnapIdResponse: Response {
    
    let code: Int32?
    let snap: SnapWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.snap = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.snap = SnapWrapper(content: value["data"])
    }
}

class GetSnapsSnapIdActionsRequest: Request {
    
    let snapId: String
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
        return "/snaps/\(snapId)/actions"
    }
    var page: String?
    var count: Int32?
    var owner: Int64?
    init(snapId: String) {
        self.snapId = snapId
    }
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = page {
            result["p"] = tmp.asRequestContent()
        }
        if let tmp = count {
            result["count"] = tmp.asRequestContent()
        }
        if let tmp = owner {
            result["owner"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetSnapsSnapIdActionsResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetSnapsSnapIdActionsResponse> {
        let future: RequestFuture<GetSnapsSnapIdActionsResponse> = client.send(self)
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

class PostSnapsSnapIdActionsRequest: Request {
    
    let snapId: String
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
        return "/snaps/\(snapId)/actions"
    }
    var type: String?
    var text: String?
    var owner: Int64?
    init(snapId: String) {
        self.snapId = snapId
    }
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = type {
            result["type"] = tmp.asRequestContent()
        }
        if let tmp = text {
            result["text"] = tmp.asRequestContent()
        }
        if let tmp = owner {
            result["owner"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PostSnapsSnapIdActionsResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostSnapsSnapIdActionsResponse> {
        let future: RequestFuture<PostSnapsSnapIdActionsResponse> = client.send(self)
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

struct GetSnapsSnapIdActionsResponse: Response {
    
    let code: Int32?
    let pagination: PaginationStruct?
    let snapActions: SnapActionsCollectionStruct?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.pagination = nil
            self.snapActions = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.pagination = PaginationStruct(content: value["pagination"])
        self.snapActions = SnapActionsCollectionStruct(content: value["data"])
    }
}

struct PostSnapsSnapIdActionsResponse: Response {
    
    let code: Int32?
    let snapAction: SnapActionWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.snapAction = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.snapAction = SnapActionWrapper(content: value["data"])
    }
}

class PostSnapsShareRequest: Request {
    
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
        return "/snaps/share"
    }
    var snapId: [String]?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = snapId {
            let tmp = tmp.asRequestContent()
            result["snap_id"] = tmp
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PostSnapsShareResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostSnapsShareResponse> {
        let future: RequestFuture<PostSnapsShareResponse> = client.send(self)
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

struct PostSnapsShareResponse: Response {
    
    let code: Int32?
    let tokens: TokensWrapper?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.tokens = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.tokens = TokensWrapper(content: value["data"])
    }
}

class GetEMojiConfigRequest: Request {
    
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
        return "/configs/hippocampus/smilies.json"
    }
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (GetEMojiConfigResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetEMojiConfigResponse> {
        let future: RequestFuture<GetEMojiConfigResponse> = client.send(self)
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

struct GetEMojiConfigResponse: Response {
    
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
    }
}
