//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL


class GetApplicationSettingsRequest: HTTPIDLRequest {
    
    static let defaultMethod: String = "GET"
    var method: String = GetApplicationSettingsRequest.defaultMethod
    var configuration: HTTPIDLConfiguration = BaseHTTPIDLConfiguration.shared
    var client: HTTPIDLClient = HTTPIDLBaseClient.shared
    var uri: String {
        get {
            return "/application/settings"
        }
    }
    var x: Int64?
    var parameters: [HTTPIDLParameter] {
        var result: [HTTPIDLParameter] = []
        if let tmp = x {
            result.append(tmp.asHTTPIDLParameter(key: "x"))
        }
        return result
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetApplicationSettingsRequest.defaultEncoder, completion: @escaping (GetApplicationSettingsResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetApplicationSettingsRequest.defaultEncoder, completion: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: completion, errorHandler: errorHandler)
    }
}

struct GetApplicationSettingsResponse: HTTPIDLResponse {
    
    let tttt: String?
    var json: Any?
    let rawResponse: HTTPResponse?
    static var decoder: HTTPResponseBodyJSONDecoder = HTTPResponseBodyJSONDecoder.shared
    init(httpResponse: HTTPResponse) throws {
        guard let httpBody = httpResponse.body else {
            self.init(json: nil, rawResponse: httpResponse)
            return
        }
        let tmp = try GetApplicationSettingsResponse.decoder.decode(httpBody)
        self.init(json: tmp, rawResponse: httpResponse)
    }
    init(json: Any?, rawResponse: HTTPResponse?) {
        self.rawResponse = rawResponse
        if let json = json as? [String: Any] {
            self.json = json
            self.tttt = String(with: json["jfjjfjfjfj"])
        } else {
            self.json = nil
            self.tttt = nil
        }
    }
}
