//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL

struct FeedResponse {
    
    var feed: [FeedStruct]?
}

extension FeedResponse: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        if let content = value["feed"] {
            let feed = [FeedStruct](content: content)
            self.feed = feed
        } else {
            self.feed = nil
        }
    }
}

struct FeedStruct {
    
    var user: UserStruct?
    var createAt: Date?
    var updatedAt: Date?
    var snaps: [SnapStruct]?
}

extension FeedStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.user = UserStruct(content: value["user"])
        self.createAt = Date(content: value["created_at"])
        self.updatedAt = Date(content: value["updated_at"])
        if let content = value["snaps"] {
            let snaps = [SnapStruct](content: content)
            self.snaps = snaps
        } else {
            self.snaps = nil
        }
    }
}

struct UserStruct {
    
    var id: Int64?
    var name: String?
    var avatarUrl: String?
    var snapsCount: Int32?
    var isFriend: Bool?
    var privacyLevel: String?
}

extension UserStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.id = Int64(content: value["id"])
        self.name = String(content: value["name"])
        self.avatarUrl = String(content: value["avatar_url"])
        self.snapsCount = Int32(content: value["snaps_count"])
        self.isFriend = Bool(content: value["is_followed"])
        self.privacyLevel = String(content: value["privacy_level"])
    }
}

struct SnapStruct {
    
    var id: Int64?
    var userId: Int64?
    var type: String?
    var width: Int32?
    var height: Int32?
    var createAt: Date?
    var taken: Date?
    var duration: Int32?
    var url: String?
    var thumbnailUrl: String?
}

extension SnapStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.id = Int64(content: value["id"])
        self.userId = Int64(content: value["user_id"])
        self.type = String(content: value["type"])
        self.width = Int32(content: value["width"])
        self.height = Int32(content: value["height"])
        self.createAt = Date(content: value["created_at"])
        self.taken = Date(content: value["taken"])
        self.duration = Int32(content: value["duration"])
        self.url = String(content: value["url"])
        self.thumbnailUrl = String(content: value["thumbnail_url"])
    }
}

struct PaginationStruct {
    
    var next: String?
    var prev: String?
    var hasMore: Int32?
}

extension PaginationStruct: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.next = String(content: value["next"])
        self.prev = String(content: value["prev"])
        self.hasMore = Int32(content: value["has_more"])
    }
}

class GetFeedRequest: Request {
    
    var method: String = "GET"
    private var _configuration: RequestConfiguration?
    var configuration: RequestConfiguration {
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
    var client: Client = BaseClient.shared
    var uri: String {
        return "/feed"
    }
    
    var p: String?
    var count: Int32?
    
    let keyOfP = "p"
    let keyOfCount = "count"
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = p {
            result["p"] = tmp.asRequestContent()
        }
        if let tmp = count {
            result["count"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetFeedResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetFeedResponse> {
        let future: RequestFuture<GetFeedResponse> = client.send(self)
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

struct GetFeedResponse: Response {
    
    let code: Int32?
    let data: FeedResponse?
    let pagination: PaginationStruct?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.data = nil
            self.pagination = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.data = FeedResponse(content: value["data"])
        self.pagination = PaginationStruct(content: value["pagination"])
    }
}
