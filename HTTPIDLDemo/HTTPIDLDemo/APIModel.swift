import Foundation
import Alamofire
struct ApplicationSettingsStruct: JSONObject {
    let tagVersion: Int32?
    let smsCode: String?
    init?(with json: Any?) {
        if let json = json as? [String: Any] {
            self.tagVersion = Int32(with: json["system_tag_version"])
            self.smsCode = String(with: json["sms_code_number"])
        } else {
            return nil
        }
    }
}
class GETapplicationsettingsRequest {
    var test: Int32?
    init() {
    }
    func parameters() -> [String: Any] {
        var result: [String: Any] = [:]
        if let tmp = test {
            result["test"] = tmp
        }
        return result
    }
    func send(with completion: @escaping (GETapplicationsettingsResponse?, Error?) -> Void) {
        Alamofire.request(HTTPIDLBaseURLString + "/application/settings", method:.get, parameters: parameters(), encoding: URLEncoding(), headers: nil).responseJSON { (response) in
            switch response.result {
                case .failure(let error):
                    completion(nil, error)
                case .success(let data):
                    let responseModel = GETapplicationsettingsResponse(with: data)
                    completion(responseModel, nil)
            }
        }
    }
}
struct GETapplicationsettingsResponse: JSONObject {
    let settings: ApplicationSettingsStruct?
    init?(with json: Any?) {
        if let json = json as? [String: Any] {
            self.settings = ApplicationSettingsStruct(with: json["data"])
        } else {
            return nil
        }
    }
}
