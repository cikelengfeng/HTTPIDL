//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL


struct OnlineStickerTemplate: ResponseContentConvertible {
    
    let url: String?
    let x: Double?
    let y: Double?
    let width: Double?
    let height: Double?
    let angle: Double?
    let defaultMap: String?
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.url = String(content: value["url"])
        self.x = Double(content: value["x"])
        self.y = Double(content: value["y"])
        self.width = Double(content: value["w"])
        self.height = Double(content: value["h"])
        self.angle = Double(content: value["angle"])
        self.defaultMap = String(content: value["defaultMap"])
    }
}

class GetTestUrlencodedQueryEncoderRequest: Request {
    
    static let defaultMethod: String = "GET"
    var method: String = GetTestUrlencodedQueryEncoderRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/test/urlencoded/query/encoder"
        }
    }
    var t1: Int64?
    var t2: Int32?
    var t3: Double?
    var t4: String?
    var content: RequestContent? {
        var result = [String:RequestContent]()
        if let tmp = t1 {
            result["t"] = tmp.asRequestContent()
        }
        if let tmp = t2 {
            result["tt"] = tmp.asRequestContent()
        }
        if let tmp = t3 {
            result["ttt"] = tmp.asRequestContent()
        }
        if let tmp = t4 {
            result["tttt"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetTestUrlencodedQueryEncoderRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = GetTestUrlencodedQueryEncoderResponse.defaultDecoder, completion: @escaping (GetTestUrlencodedQueryEncoderResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetTestUrlencodedQueryEncoderRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
    }
}

struct GetTestUrlencodedQueryEncoderResponse: Response {
    
    let x1: String?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.x1 = nil
            return
        }
        self.x1 = String(content: value["x"])
    }
}

class PostTestUrlencodedFormEncoderRequest: Request {
    
    static let defaultMethod: String = "POST"
    var method: String = PostTestUrlencodedFormEncoderRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/test/urlencoded/form/encoder"
        }
    }
    var t1: Int64?
    var t2: Int32?
    var t3: Double?
    var t4: String?
    var content: RequestContent? {
        var result = [String:RequestContent]()
        if let tmp = t1 {
            result["t"] = tmp.asRequestContent()
        }
        if let tmp = t2 {
            result["tt"] = tmp.asRequestContent()
        }
        if let tmp = t3 {
            result["ttt"] = tmp.asRequestContent()
        }
        if let tmp = t4 {
            result["tttt"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = PostTestUrlencodedFormEncoderRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = PostTestUrlencodedFormEncoderResponse.defaultDecoder, completion: @escaping (PostTestUrlencodedFormEncoderResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = PostTestUrlencodedFormEncoderRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
    }
}

struct PostTestUrlencodedFormEncoderResponse: Response {
    
    let x1: String?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.x1 = nil
            return
        }
        self.x1 = String(content: value["x"])
    }
}

class PostTestMultipartEncoderRequest: Request {
    
    static let defaultMethod: String = "POST"
    var method: String = PostTestMultipartEncoderRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/test/multipart/encoder"
        }
    }
    var number: Int64?
    var bool: Bool?
    var string: String?
    var data: HTTPData?
    var file: HTTPFile?
    var content: RequestContent? {
        var result = [String:RequestContent]()
        if let tmp = number {
            result["number"] = tmp.asRequestContent()
        }
        if let tmp = bool {
            result["bool"] = tmp.asRequestContent()
        }
        if let tmp = string {
            result["string"] = tmp.asRequestContent()
        }
        if let tmp = data {
            result["data"] = tmp.asRequestContent()
        }
        if let tmp = file {
            result["file"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = PostTestMultipartEncoderRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = PostTestMultipartEncoderResponse.defaultDecoder, completion: @escaping (PostTestMultipartEncoderResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = PostTestMultipartEncoderRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
    }
}

struct PostTestMultipartEncoderResponse: Response {
    
    let x1: String?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.x1 = nil
            return
        }
        self.x1 = String(content: value["x"])
    }
}

class PostTestJsonEncoderRequest: Request {
    
    static let defaultMethod: String = "POST"
    var method: String = PostTestJsonEncoderRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/test/json/encoder"
        }
    }
    var t1: Int64?
    var t2: Int32?
    var t3: Double?
    var t4: String?
    var t5: [String]?
    var content: RequestContent? {
        var result = [String:RequestContent]()
        if let tmp = t1 {
            result["t"] = tmp.asRequestContent()
        }
        if let tmp = t2 {
            result["tt"] = tmp.asRequestContent()
        }
        if let tmp = t3 {
            result["ttt"] = tmp.asRequestContent()
        }
        if let tmp = t4 {
            result["tttt"] = tmp.asRequestContent()
        }
        if let tmp = t5 {
            result["ttttt"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = PostTestJsonEncoderRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = PostTestJsonEncoderResponse.defaultDecoder, completion: @escaping (PostTestJsonEncoderResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = PostTestJsonEncoderRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
    }
}

struct PostTestJsonEncoderResponse: Response {
    
    let x1: String?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.x1 = nil
            return
        }
        self.x1 = String(content: value["x"])
    }
}

class GetStickerMediaIdRequest: Request {
    
    let mediaId: String
    static let defaultMethod: String = "GET"
    var method: String = GetStickerMediaIdRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/sticker/\(mediaId)"
        }
    }
    var defaultMap: String?
    init(mediaId: String) {
        self.mediaId = mediaId
    }
    var content: RequestContent? {
        var result = [String:RequestContent]()
        if let tmp = defaultMap {
            result["defaultMap"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetStickerMediaIdRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = GetStickerMediaIdResponse.defaultDecoder, completion: @escaping (GetStickerMediaIdResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetStickerMediaIdRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
    }
}

struct GetStickerMediaIdResponse: Response {
    
    let code: Int32?
    let templates: [OnlineStickerTemplate]?
    let defaultMap: String?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            self.templates = nil
            self.defaultMap = nil
            return
        }
        self.code = Int32(content: value["code"])
        self.templates = [OnlineStickerTemplate](content: value["data"])
        self.defaultMap = String(content: value["defaultMap"])
    }
}

class GetUnderLineRequest: Request {
    
    static let defaultMethod: String = "GET"
    var method: String = GetUnderLineRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/under_line"
        }
    }
    var content: RequestContent? = nil
    func send(_ requestEncoder: HTTPRequestEncoder = GetUnderLineRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = GetUnderLineResponse.defaultDecoder, completion: @escaping (GetUnderLineResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetUnderLineRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
    }
}

struct GetUnderLineResponse: Response {
    
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            return
        }
    }
}
