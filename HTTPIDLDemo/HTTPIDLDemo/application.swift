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
            let tmp = tmp.asRequestContent()
            result["ttttt"] = tmp
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
    }
}

class GetTestNestedMessageRequest: Request {
    
    static let defaultMethod: String = "GET"
    var method: String = GetTestNestedMessageRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/test/nested/message"
        }
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
        var result = [String:RequestContent]()
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
    func send(_ requestEncoder: HTTPRequestEncoder = GetTestNestedMessageRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = GetTestNestedMessageResponse.defaultDecoder, completion: @escaping (GetTestNestedMessageResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetTestNestedMessageRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
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
