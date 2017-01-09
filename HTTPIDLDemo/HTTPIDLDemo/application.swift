//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL


struct Testing: ResponseParameterConvertible {
    
    let sms: String?
    init?(parameter: ResponseParameter?) {
        guard let parameter = parameter, case .dictionary(let value) = parameter else {
            return nil
        }
        self.sms = String(parameter: value["sms_code_number"])
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
    var parameters: [RequestParameter] {
        var result: [RequestParameter] = []
        if let tmp = x {
            result.append(tmp.asRequestParameter(key: "x"))
        }
        return result
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
    init(parameters: [String: ResponseParameter], rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        self.tttt = String(parameter: parameters["jfjjfjfjfj"])
        self.t2 = Testing(parameter: parameters["data"])
    }
}
