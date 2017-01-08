//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL


struct Testing: HTTPIDLResponseParameterConvertible {
    
    let t1: [Int32]?
    let t2: [String: String]?
    let t3: Double?
    init?(parameter: HTTPIDLResponseParameter) {
        guard case .dictionary(value) = parameter else {
            return nil
        }
        self.t1 = [Int32](parameter: value["t"])
        self.t2 = [String: String](parameter: value["tt"])
        self.t3 = Double(parameter: value["ttt"])
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
    func send(_ requestEncoder: HTTPRequestEncoder = GetApplicationSettingsRequest.defaultEncoder, completion: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: completion, errorHandler: errorHandler)
    }
}

struct GetApplicationSettingsResponse: HTTPIDLResponse {
    
    let tttt: String?
    let test: Testing?
    let rawResponse: HTTPResponse
    init(parameters: [String: HTTPIDLResponseParameter], rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        self.tttt = String(parameter: parameters["jfjjfjfjfj"])
        self.test = Testing(parameter: parameters["jude"])
    }
}
