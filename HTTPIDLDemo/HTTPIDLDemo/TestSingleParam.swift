//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL

struct TSPStruct1 {
    
    var a: Int32?
    var b: String?
    var c: [[String: Int64]]?
    var d: [String: [Int64]]?
}

extension TSPStruct1: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.a = Int32(content: value["a"])
        self.b = String(content: value["bc"])
        if let content = value["c"] {
            var c: [[String: Int64]]? = nil
            if case .array(let value) = content {
                c = [[String: Int64]]()
                value.forEach { (content) in
                    let _c = [String: Int64](content: content)
                    if let tmp = _c {
                        c!.append(tmp)
                    }
                }
            }
            self.c = c
        } else {
            self.c = nil
        }
        if let content = value["df"] {
            var d: [String: [Int64]]? = nil
            if case .dictionary(let value) = content {
                d = [String: [Int64]]()
                value.forEach { (kv) in
                    let content = kv.value
                    let _d = [Int64](content: content)
                    if let tmp = _d {
                        d!.updateValue(tmp, forKey: kv.key)
                    }
                }
            }
            self.d = d
        } else {
            self.d = nil
        }
    }
}

extension TSPStruct1: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        var result = [String: RequestContent]()
        if let tmp = a {
            result["a"] = tmp.asRequestContent()
        }
        if let tmp = b {
            result["bc"] = tmp.asRequestContent()
        }
        if let tmp = c {
            let tmp = tmp.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                guard case .array(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.asRequestContent()
                content.append(tmp)
                return .array(value: content)
            })
            result["c"] = tmp
        }
        if let tmp = d {
            let tmp = tmp.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent in
                guard case .dictionary(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.value.asRequestContent()
                content[soGood.key.asHTTPParamterKey()] = tmp
                return .dictionary(value: content)
            })
            result["df"] = tmp
        }
        return .dictionary(value: result)
    }
}

struct TSPStruct2 {
    
    var body: Int32?
}

extension TSPStruct2: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        self.body = Int32(content: content)
    }
}

extension TSPStruct2: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        if let body = body {
            return body.asRequestContent()
        } else {
            return .dictionary(value: [:])
        }
    }
}

struct TSPStruct3 {
    
    var body: [[String: Int64]]?
}

extension TSPStruct3: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        var body: [[String: Int64]]? = nil
        if case .array(let value) = content {
            body = [[String: Int64]]()
            value.forEach { (content) in
                let _body = [String: Int64](content: content)
                if let tmp = _body {
                    body!.append(tmp)
                }
            }
        }
        self.body = body
    }
}

extension TSPStruct3: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        if let body = body {
            let tmp = body.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                guard case .array(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.asRequestContent()
                content.append(tmp)
                return .array(value: content)
            })
            return tmp
        } else {
            return .dictionary(value: [:])
        }
    }
}

struct TSPStruct4 {
    
    var body: [String: [Int64]]?
}

extension TSPStruct4: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        var body: [String: [Int64]]? = nil
        if case .dictionary(let value) = content {
            body = [String: [Int64]]()
            value.forEach { (kv) in
                let content = kv.value
                let _body = [Int64](content: content)
                if let tmp = _body {
                    body!.updateValue(tmp, forKey: kv.key)
                }
            }
        }
        self.body = body
    }
}

extension TSPStruct4: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        if let body = body {
            let tmp = body.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent in
                guard case .dictionary(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.value.asRequestContent()
                content[soGood.key.asHTTPParamterKey()] = tmp
                return .dictionary(value: content)
            })
            return tmp
        } else {
            return .dictionary(value: [:])
        }
    }
}

struct TSPStruct5 {
    
    var body: TSPStruct1?
}

extension TSPStruct5: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        self.body = TSPStruct1(content: content)
    }
}

extension TSPStruct5: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        if let body = body {
            return body.asRequestContent()
        } else {
            return .dictionary(value: [:])
        }
    }
}

struct TSPStruct6 {
    
    var body: TSPStruct2?
}

extension TSPStruct6: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        self.body = TSPStruct2(content: content)
    }
}

extension TSPStruct6: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        if let body = body {
            return body.asRequestContent()
        } else {
            return .dictionary(value: [:])
        }
    }
}

struct TSPStruct7 {
    
    var body: TSPStruct3?
}

extension TSPStruct7: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        self.body = TSPStruct3(content: content)
    }
}

extension TSPStruct7: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        if let body = body {
            return body.asRequestContent()
        } else {
            return .dictionary(value: [:])
        }
    }
}

struct TSPStruct8 {
    
    var body: TSPStruct4?
}

extension TSPStruct8: ResponseContentConvertible {
    
    init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        self.body = TSPStruct4(content: content)
    }
}

extension TSPStruct8: RequestContentConvertible {
    
    func asRequestContent() -> RequestContent {
        if let body = body {
            return body.asRequestContent()
        } else {
            return .dictionary(value: [:])
        }
    }
}

class GetArrayRequest: Request {
    
    var method: String = "GET"
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
        return "/array"
    }
    
    var body: [[String: Int64]]?
    var content: RequestContent? {
        if let body = body {
            let tmp = body.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in
                guard case .array(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.asRequestContent()
                content.append(tmp)
                return .array(value: content)
            })
            return tmp
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetArrayResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetArrayResponse> {
        let future: RequestFuture<GetArrayResponse> = manager.send(self)
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

struct GetArrayResponse: Response {
    
    let body: [[String: String]]?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        var body: [[String: String]]? = nil
        if case .array(let value) = content {
            body = [[String: String]]()
            value.forEach { (content) in
                let _body = [String: String](content: content)
                if let tmp = _body {
                    body!.append(tmp)
                }
            }
        }
        self.body = body
    }
}

class GetDictRequest: Request {
    
    var method: String = "GET"
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
        return "/dict"
    }
    
    var body: [String: [Int64]]?
    var content: RequestContent? {
        if let body = body {
            let tmp = body.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent in
                guard case .dictionary(var content) = soFar else {
                    return soFar
                }
                let tmp = soGood.value.asRequestContent()
                content[soGood.key.asHTTPParamterKey()] = tmp
                return .dictionary(value: content)
            })
            return tmp
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetDictResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetDictResponse> {
        let future: RequestFuture<GetDictResponse> = manager.send(self)
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

struct GetDictResponse: Response {
    
    let body: [String: [String]]?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        var body: [String: [String]]? = nil
        if case .dictionary(let value) = content {
            body = [String: [String]]()
            value.forEach { (kv) in
                let content = kv.value
                let _body = [String](content: content)
                if let tmp = _body {
                    body!.updateValue(tmp, forKey: kv.key)
                }
            }
        }
        self.body = body
    }
}

class GetSimpleRequest: Request {
    
    var method: String = "GET"
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
        return "/simple"
    }
    
    var body: Int64?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetSimpleResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetSimpleResponse> {
        let future: RequestFuture<GetSimpleResponse> = manager.send(self)
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

struct GetSimpleResponse: Response {
    
    let body: String?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = String(content: content)
    }
}

class PostFileRequest: Request {
    
    var method: String = "POST"
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
        return "/file"
    }
    
    var body: HTTPFile?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (PostFileResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostFileResponse> {
        let future: RequestFuture<PostFileResponse> = manager.send(self)
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

struct PostFileResponse: Response {
    
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
    }
}

class PostDataRequest: Request {
    
    var method: String = "POST"
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
        return "/data"
    }
    
    var body: HTTPData?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (PostDataResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<PostDataResponse> {
        let future: RequestFuture<PostDataResponse> = manager.send(self)
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

struct PostDataResponse: Response {
    
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
    }
}

class GetStruct1Request: Request {
    
    var method: String = "GET"
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
        return "/struct1"
    }
    
    var body: TSPStruct1?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetStruct1Response) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStruct1Response> {
        let future: RequestFuture<GetStruct1Response> = manager.send(self)
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

struct GetStruct1Response: Response {
    
    let body: TSPStruct1?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = TSPStruct1(content: content)
    }
}

class GetStruct2Request: Request {
    
    var method: String = "GET"
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
        return "/struct2"
    }
    
    var body: TSPStruct2?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetStruct2Response) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStruct2Response> {
        let future: RequestFuture<GetStruct2Response> = manager.send(self)
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

struct GetStruct2Response: Response {
    
    let body: TSPStruct2?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = TSPStruct2(content: content)
    }
}

class GetStruct3Request: Request {
    
    var method: String = "GET"
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
        return "/struct3"
    }
    
    var body: TSPStruct3?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetStruct3Response) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStruct3Response> {
        let future: RequestFuture<GetStruct3Response> = manager.send(self)
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

struct GetStruct3Response: Response {
    
    let body: TSPStruct3?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = TSPStruct3(content: content)
    }
}

class GetStruct4Request: Request {
    
    var method: String = "GET"
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
        return "/struct4"
    }
    
    var body: TSPStruct4?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetStruct4Response) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStruct4Response> {
        let future: RequestFuture<GetStruct4Response> = manager.send(self)
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

struct GetStruct4Response: Response {
    
    let body: TSPStruct4?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = TSPStruct4(content: content)
    }
}

class GetStruct5Request: Request {
    
    var method: String = "GET"
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
        return "/struct5"
    }
    
    var body: TSPStruct5?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetStruct5Response) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStruct5Response> {
        let future: RequestFuture<GetStruct5Response> = manager.send(self)
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

struct GetStruct5Response: Response {
    
    let body: TSPStruct5?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = TSPStruct5(content: content)
    }
}

class GetStruct6Request: Request {
    
    var method: String = "GET"
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
        return "/struct6"
    }
    
    var body: TSPStruct6?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetStruct6Response) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStruct6Response> {
        let future: RequestFuture<GetStruct6Response> = manager.send(self)
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

struct GetStruct6Response: Response {
    
    let body: TSPStruct6?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = TSPStruct6(content: content)
    }
}

class GetStruct7Request: Request {
    
    var method: String = "GET"
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
        return "/struct7"
    }
    
    var body: TSPStruct7?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetStruct7Response) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStruct7Response> {
        let future: RequestFuture<GetStruct7Response> = manager.send(self)
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

struct GetStruct7Response: Response {
    
    let body: TSPStruct7?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = TSPStruct7(content: content)
    }
}

class GetStruct8Request: Request {
    
    var method: String = "GET"
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
        return "/struct8"
    }
    
    var body: TSPStruct8?
    var content: RequestContent? {
        if let body = body {
            return body.asRequestContent()
        } else {
            return nil
        }
    }
    
    @discardableResult
    func send(completion: @escaping (GetStruct8Response) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetStruct8Response> {
        let future: RequestFuture<GetStruct8Response> = manager.send(self)
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

struct GetStruct8Response: Response {
    
    let body: TSPStruct8?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content else {
            self.body = nil
            return
        }
        self.body = TSPStruct8(content: content)
    }
}
