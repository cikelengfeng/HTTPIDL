//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL


struct Testing: HTTPIDLResponseParameterConvertible {
    
    let sms: String?
    init?(parameter: HTTPIDLResponseParameter?) {
        guard let parameter = parameter, case .dictionary(let value) = parameter else {
            return nil
        }
        self.sms = String(parameter: value["sms_code_number"])
    }
}

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
    var parameters: [HTTPIDLRequestParameter] {
        var result: [HTTPIDLRequestParameter] = []
        if let tmp = x {
            result.append(tmp.asHTTPIDLRequestParameter(key: "x"))
        }
        return result
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetApplicationSettingsRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = GetApplicationSettingsResponse.defaultDecoder, completion: @escaping (GetApplicationSettingsResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetApplicationSettingsRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
    }
}

struct GetApplicationSettingsResponse: HTTPIDLResponse {
    
    let tttt: String?
    let t2: Testing?
    let rawResponse: HTTPResponse
    init(parameters: [String: HTTPIDLResponseParameter], rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        self.tttt = String(parameter: parameters["jfjjfjfjfj"])
        self.t2 = Testing(parameter: parameters["data"])
    }
}
