//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL


struct Testing: ResponseContentConvertible {
    
    let sms: String?
    init?(content: ResponseContent?) {
        guard let content = content, case .dictionary(let value) = content else {
            return nil
        }
        self.sms = String(content: value["sms_code_number"])
    }
}

class GetApplicationSettingsRequest: Request {
    
    static let defaultMethod: String = "GET"
    var method: String = GetApplicationSettingsRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/application/settings"
        }
    }
    var x: Int64?
    var content: RequestContent? {
        var result = [String:RequestContent]()
        if let tmp = x {
            result["x"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetApplicationSettingsRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = GetApplicationSettingsResponse.defaultDecoder, completion: @escaping (GetApplicationSettingsResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetApplicationSettingsRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
    }
}

struct GetApplicationSettingsResponse: Response {
    
    let tttt: String?
    let t2: Testing?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.tttt = nil
            self.t2 = nil
            return
        }
        self.tttt = String(content: value["jfjjfjfjfj"])
        self.t2 = Testing(content: value["data"])
    }
}
