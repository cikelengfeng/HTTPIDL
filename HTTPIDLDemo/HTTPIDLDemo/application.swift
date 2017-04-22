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

struct TestNestedStruct: ResponseContentConvertible {
    
    let a: [String]?
    let d: [String: String]?
    let aa: [[String]]?
    let ad: [[String: String]]?
    let dd: [String: [String: String]]?
    let da: [String: [String]]?
    let dada: [String: [[String: [String]]]]?
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        if let content = value["a"] {
            let a = [String](content: content)
            self.a = a
        } else {
            self.a = nil
        }
        if let content = value["d"] {
            let d = [String: String](content: content)
            self.d = d
        } else {
            self.d = nil
        }
        if let content = value["aa"] {
            var aa: [[String]]? = nil
            if case .array(let value) = content {
                aa = [[String]]()
                value.forEach { (content) in
                    let _aa = [String](content: content)
                    if let tmp = _aa {
                        aa!.append(tmp)
                    }
                }
            }
            self.aa = aa
        } else {
            self.aa = nil
        }
        if let content = value["ad"] {
            var ad: [[String: String]]? = nil
            if case .array(let value) = content {
                ad = [[String: String]]()
                value.forEach { (content) in
                    let _ad = [String: String](content: content)
                    if let tmp = _ad {
                        ad!.append(tmp)
                    }
                }
            }
            self.ad = ad
        } else {
            self.ad = nil
        }
        if let content = value["dd"] {
            var dd: [String: [String: String]]? = nil
            if case .dictionary(let value) = content {
                dd = [String: [String: String]]()
                value.forEach { (kv) in
                    let content = kv.value
                    let _dd = [String: String](content: content)
                    if let tmp = _dd {
                        dd!.updateValue(tmp, forKey: kv.key)
                    }
                }
            }
            self.dd = dd
        } else {
            self.dd = nil
        }
        if let content = value["da"] {
            var da: [String: [String]]? = nil
            if case .dictionary(let value) = content {
                da = [String: [String]]()
                value.forEach { (kv) in
                    let content = kv.value
                    let _da = [String](content: content)
                    if let tmp = _da {
                        da!.updateValue(tmp, forKey: kv.key)
                    }
                }
            }
            self.da = da
        } else {
            self.da = nil
        }
        if let content = value["dada"] {
            var dada: [String: [[String: [String]]]]? = nil
            if case .dictionary(let value) = content {
                dada = [String: [[String: [String]]]]()
                value.forEach { (kv) in
                    let content = kv.value
                    var _dada: [[String: [String]]]? = nil
                    if case .array(let value) = content {
                        _dada = [[String: [String]]]()
                        value.forEach { (content) in
                            var __dada: [String: [String]]? = nil
                            if case .dictionary(let value) = content {
                                __dada = [String: [String]]()
                                value.forEach { (kv) in
                                    let content = kv.value
                                    let ___dada = [String](content: content)
                                    if let tmp = ___dada {
                                        __dada!.updateValue(tmp, forKey: kv.key)
                                    }
                                }
                            }
                            if let tmp = __dada {
                                _dada!.append(tmp)
                            }
                        }
                    }
                    if let tmp = _dada {
                        dada!.updateValue(tmp, forKey: kv.key)
                    }
                }
            }
            self.dada = dada
        } else {
            self.dada = nil
        }
    }
}

struct HTTPBinGetArgs: ResponseContentConvertible {
    
    let int64: Int64?
    let int32: Int32?
    let bool: Bool?
    let double: Double?
    let string: String?
    let array: [String]?
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.int64 = Int64(content: value["int64"])
        self.int32 = Int32(content: value["int32"])
        self.bool = Bool(content: value["bool"])
        self.double = Double(content: value["double"])
        self.string = String(content: value["string"])
        if let content = value["array"] {
            let array = [String](content: content)
            self.array = array
        } else {
            self.array = nil
        }
    }
}

class GetTestUrlencodedQueryEncoderRequest: Request {
    
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/test/urlencoded/query/encoder"
    }
    var t1: Int64?
    var t2: Int32?
    var t3: Double?
    var t4: String?
    var content: RequestContent? {
        var result = [String: RequestContent]()
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
    
    @discardableResult
    func send(completion: @escaping (GetTestUrlencodedQueryEncoderResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetTestUrlencodedQueryEncoderResponse> {
        let future: RequestFuture<GetTestUrlencodedQueryEncoderResponse> = client.send(self)
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
    
    var method: String = "POST"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/test/urlencoded/form/encoder"
    }
    var t1: Int64?
    var t2: Int32?
    var t3: Double?
    var t4: String?
    var content: RequestContent? {
        var result = [String: RequestContent]()
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
    
    @discardableResult
    func send(completion: @escaping (PostTestUrlencodedFormEncoderResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostTestUrlencodedFormEncoderResponse> {
        let future: RequestFuture<PostTestUrlencodedFormEncoderResponse> = client.send(self)
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
    
    var method: String = "POST"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/test/multipart/encoder"
    }
    var number: Int64?
    var bool: Bool?
    var string: String?
    var data: HTTPData?
    var file: HTTPFile?
    var content: RequestContent? {
        var result = [String: RequestContent]()
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
    
    @discardableResult
    func send(completion: @escaping (PostTestMultipartEncoderResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostTestMultipartEncoderResponse> {
        let future: RequestFuture<PostTestMultipartEncoderResponse> = client.send(self)
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
    
    var method: String = "POST"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/test/json/encoder"
    }
    var t1: Int64?
    var t2: Int32?
    var t3: Double?
    var t4: String?
    var t5: [String]?
    var content: RequestContent? {
        var result = [String: RequestContent]()
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
            let tmp = tmp.asRequestContent()
            result["ttttt"] = tmp
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PostTestJsonEncoderResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostTestJsonEncoderResponse> {
        let future: RequestFuture<PostTestJsonEncoderResponse> = client.send(self)
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
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/sticker/\(mediaId)"
    }
    var defaultMap: String?
    init(mediaId: String) {
        self.mediaId = mediaId
    }
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = defaultMap {
            result["defaultMap"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetStickerMediaIdResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStickerMediaIdResponse> {
        let future: RequestFuture<GetStickerMediaIdResponse> = client.send(self)
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
        if let content = value["data"] {
            let templates = [OnlineStickerTemplate](content: content)
            self.templates = templates
        } else {
            self.templates = nil
        }
        self.defaultMap = String(content: value["defaultMap"])
    }
}

class GetUnderLineRequest: Request {
    
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/under_line"
    }
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (GetUnderLineResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetUnderLineResponse> {
        let future: RequestFuture<GetUnderLineResponse> = client.send(self)
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

struct GetUnderLineResponse: Response {
    
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
    }
}

class GetTestNestedMessageRequest: Request {
    
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/test/nested/message"
    }
    var a1: [String]?
    var d1: [String: String]?
    var aaa1: [[[String]]]?
    var ad1: [[String: String]]?
    var dd1: [String: [String: String]]?
    var da1: [String: [String]]?
    var dada1: [String: [[String: [String]]]]?
    var adad1: [[String: [[String: String]]]]?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = a1 {
            let tmp = tmp.asRequestContent()
            result["ae"] = tmp
        }
        if let tmp = d1 {
            let tmp = tmp.asRequestContent()
            result["de"] = tmp
        }
        if let tmp = aaa1 {
            let tmp = tmp.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                guard case .array(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                    guard case .array(var content) = soFar else {
                        return soFar
                    }
                    let tmp = soGood.asRequestContent()
                    content.append(tmp)
                    return .array(value: content)
                })
                content.append(tmp)
                return .array(value: content)
            })
            result["aaae"] = tmp
        }
        if let tmp = ad1 {
            let tmp = tmp.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                guard case .array(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.asRequestContent()
                content.append(tmp)
                return .array(value: content)
            })
            result["ade"] = tmp
        }
        if let tmp = dd1 {
            let tmp = tmp.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent in
                guard case .dictionary(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.value.asRequestContent()
                content[soGood.key.asHTTPParamterKey()] = tmp
                return .dictionary(value: content)
            })
            result["dde"] = tmp
        }
        if let tmp = da1 {
            let tmp = tmp.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent in
                guard case .dictionary(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.value.asRequestContent()
                content[soGood.key.asHTTPParamterKey()] = tmp
                return .dictionary(value: content)
            })
            result["dae"] = tmp
        }
        if let tmp = dada1 {
            let tmp = tmp.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent in
                guard case .dictionary(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.value.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                    guard case .array(var content) = soFar else {
                        return soFar
                    }
                    let tmp = soGood.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent in
                        guard case .dictionary(var content) = soFar else {
                            return soFar
                        }
                        let tmp = soGood.value.asRequestContent()
                        content[soGood.key.asHTTPParamterKey()] = tmp
                        return .dictionary(value: content)
                    })
                    content.append(tmp)
                    return .array(value: content)
                })
                content[soGood.key.asHTTPParamterKey()] = tmp
                return .dictionary(value: content)
            })
            result["dadae"] = tmp
        }
        if let tmp = adad1 {
            let tmp = tmp.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                guard case .array(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent in
                    guard case .dictionary(var content) = soFar else {
                        return soFar
                    }
                    let tmp = soGood.value.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                        guard case .array(var content) = soFar else {
                            return soFar
                        }
                        let tmp = soGood.asRequestContent()
                        content.append(tmp)
                        return .array(value: content)
                    })
                    content[soGood.key.asHTTPParamterKey()] = tmp
                    return .dictionary(value: content)
                })
                content.append(tmp)
                return .array(value: content)
            })
            result["adade"] = tmp
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetTestNestedMessageResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetTestNestedMessageResponse> {
        let future: RequestFuture<GetTestNestedMessageResponse> = client.send(self)
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

struct GetTestNestedMessageResponse: Response {
    
    let a1: [String]?
    let d1: [String: String]?
    let aa1: [[String]]?
    let ad1: [[String: String]]?
    let dd1: [String: [String: String]]?
    let da1: [String: [String]]?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.a1 = nil
            self.d1 = nil
            self.aa1 = nil
            self.ad1 = nil
            self.dd1 = nil
            self.da1 = nil
            return
        }
        if let content = value["ae"] {
            let a1 = [String](content: content)
            self.a1 = a1
        } else {
            self.a1 = nil
        }
        if let content = value["de"] {
            let d1 = [String: String](content: content)
            self.d1 = d1
        } else {
            self.d1 = nil
        }
        if let content = value["aae"] {
            var aa1: [[String]]? = nil
            if case .array(let value) = content {
                aa1 = [[String]]()
                value.forEach { (content) in
                    let _aa1 = [String](content: content)
                    if let tmp = _aa1 {
                        aa1!.append(tmp)
                    }
                }
            }
            self.aa1 = aa1
        } else {
            self.aa1 = nil
        }
        if let content = value["ade"] {
            var ad1: [[String: String]]? = nil
            if case .array(let value) = content {
                ad1 = [[String: String]]()
                value.forEach { (content) in
                    let _ad1 = [String: String](content: content)
                    if let tmp = _ad1 {
                        ad1!.append(tmp)
                    }
                }
            }
            self.ad1 = ad1
        } else {
            self.ad1 = nil
        }
        if let content = value["dde"] {
            var dd1: [String: [String: String]]? = nil
            if case .dictionary(let value) = content {
                dd1 = [String: [String: String]]()
                value.forEach { (kv) in
                    let content = kv.value
                    let _dd1 = [String: String](content: content)
                    if let tmp = _dd1 {
                        dd1!.updateValue(tmp, forKey: kv.key)
                    }
                }
            }
            self.dd1 = dd1
        } else {
            self.dd1 = nil
        }
        if let content = value["dae"] {
            var da1: [String: [String]]? = nil
            if case .dictionary(let value) = content {
                da1 = [String: [String]]()
                value.forEach { (kv) in
                    let content = kv.value
                    let _da1 = [String](content: content)
                    if let tmp = _da1 {
                        da1!.updateValue(tmp, forKey: kv.key)
                    }
                }
            }
            self.da1 = da1
        } else {
            self.da1 = nil
        }
    }
}

class GetGetRequest: Request {
    
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/get"
    }
    var int64: Int64?
    var int32: Int32?
    var bool: Bool?
    var double: Double?
    var string: String?
    var array: [String]?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = int64 {
            result["int64"] = tmp.asRequestContent()
        }
        if let tmp = int32 {
            result["int32"] = tmp.asRequestContent()
        }
        if let tmp = bool {
            result["bool"] = tmp.asRequestContent()
        }
        if let tmp = double {
            result["double"] = tmp.asRequestContent()
        }
        if let tmp = string {
            result["string"] = tmp.asRequestContent()
        }
        if let tmp = array {
            let tmp = tmp.asRequestContent()
            result["array"] = tmp
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetGetResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetGetResponse> {
        let future: RequestFuture<GetGetResponse> = client.send(self)
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

struct GetGetResponse: Response {
    
    let args: HTTPBinGetArgs?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.args = nil
            return
        }
        self.args = HTTPBinGetArgs(content: value["args"])
    }
}

class PostPostRequest: Request {
    
    var method: String = "POST"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/post"
    }
    var data: HTTPFile?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = data {
            result["data"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (PostPostResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostPostResponse> {
        let future: RequestFuture<PostPostResponse> = client.send(self)
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

struct PostPostResponse: Response {
    
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
    }
}

class GetUnginedTestRequest: Request {
    
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/ungined/test"
    }
    var uint32: UInt32?
    var uint64: UInt64?
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = uint32 {
            result["uint32"] = tmp.asRequestContent()
        }
        if let tmp = uint64 {
            result["uint64"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetUnginedTestResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetUnginedTestResponse> {
        let future: RequestFuture<GetUnginedTestResponse> = client.send(self)
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

struct GetUnginedTestResponse: Response {
    
    let uint32: UInt32?
    let uint64: UInt64?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.uint32 = nil
            self.uint64 = nil
            return
        }
        self.uint32 = UInt32(content: value["uint32"])
        self.uint64 = UInt64(content: value["uint64"])
    }
}

class GetCgi-aWxRequest: Request {
    
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/cgi-a/wx"
    }
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (GetCgi-aWxResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetCgi-aWxResponse> {
        let future: RequestFuture<GetCgi-aWxResponse> = client.send(self)
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

struct GetCgi-aWxResponse: Response {
    
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
    }
}

class GetTest%^&**(\/XxxxRequest: Request {
    
    let xxxx: String
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/test/%^&**(///\(xxxx)"
    }
    var a: Int64?
    var b: Int32?
    init(xxxx: String) {
        self.xxxx = xxxx
    }
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = a {
            result["a"] = tmp.asRequestContent()
        }
        if let tmp = b {
            result["STRING"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetTest%^&**(\/XxxxResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetTest%^&**(\/XxxxResponse> {
        let future: RequestFuture<GetTest%^&**(\/XxxxResponse> = client.send(self)
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

struct GetTest%^&**(\/XxxxResponse: Response {
    
    let c: Bool?
    let d: String?
    let e: HTTPFile?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.c = nil
            self.d = nil
            self.e = nil
            return
        }
        self.c = Bool(content: value["\;"])
        self.d = String(content: value["^&**"])
        self.e = HTTPFile(content: value["a123&*"])
    }
}

class GetTestingRequest: Request {
    
    var method: String = "GET"
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        return "/test/?/message&_name"
    }
    var content: RequestContent?
    
    @discardableResult
    func send(completion: @escaping (GetTestingResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetTestingResponse> {
        let future: RequestFuture<GetTestingResponse> = client.send(self)
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

struct GetTestingResponse: Response {
    
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
    }
}
