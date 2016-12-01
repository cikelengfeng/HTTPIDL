import Foundation
import Alamofire
struct SettingsURITemplate: JSONObject {
    let avatar: String?
    let thumbnail: String?
    let origin: String?
    init?(with json: Any?) {
        if let json = json as? [String: Any] {
            self.avatar = String(with: json["avatar"])
            self.thumbnail = String(with: json["s240"])
            self.origin = String(with: json["origin"])
        } else {
            return nil
        }
    }
}
struct SettingsOnlineFilter: JSONObject {
    let name: String?
    let displayName: String?
    init?(with json: Any?) {
        if let json = json as? [String: Any] {
            self.name = String(with: json["name"])
            self.displayName = String(with: json["display_name"])
        } else {
            return nil
        }
    }
}
struct ApplicationSettingsStruct: JSONObject {
    let tagVersion: Int32?
    let smsCode: String?
    let uriTemplateDict: [String: String]?
    let uriTemplate: SettingsURITemplate?
    let onlineFilter: [SettingsOnlineFilter]?
    init?(with json: Any?) {
        if let json = json as? [String: Any] {
            self.tagVersion = Int32(with: json["system_tag_version"])
            self.smsCode = String(with: json["sms_code_number"])
            if let anyDict = json["uri_template"] as? [String: Any] {
                var tmp: [String: String] = [:]
                anyDict.forEach({ (key, value) in
                    guard let newKey = String(with: key) else {
                        return
                    }
                    guard let newValue = String(with: value) else {
                        return
                    }
                    tmp[newKey] = newValue
                })
                if tmp.count > 0 {
                    self.uriTemplateDict = tmp
                } else {
                    self.uriTemplateDict = nil
                }
            } else {
                self.uriTemplateDict = nil
            }
            self.uriTemplate = SettingsURITemplate(with: json["uri_template"])
            if let anyArray = json["filters"] as? [Any] {
                self.onlineFilter = anyArray.flatMap { SettingsOnlineFilter(with: $0) }
            } else {
                self.onlineFilter = nil
            }
        } else {
            return nil
        }
    }
}
class GETapplicationsettingsRequest {
    var baseURLString = HTTPIDLBaseURLString
    var test: Int32?
    func parameters() -> [String: Any] {
        var result: [String: Any] = [:]
        if let tmp = test {
            result["test"] = tmp
        }
        return result
    }
    func send(with completion: @escaping (GETapplicationsettingsResponse, Error?) -> Void) {
        Alamofire.request(baseURLString + "/application/settings", method:.get, parameters: parameters(), encoding: URLEncoding(), headers: nil).responseJSON { (dataResponse) in
            switch dataResponse.result {
                case .failure(let error):
                    let responseModel = GETapplicationsettingsResponse(with: nil, rawResponse: dataResponse.response)
                    completion(responseModel, error)
                case .success(let data):
                    let responseModel = GETapplicationsettingsResponse(with: data, rawResponse: dataResponse.response)
                    completion(responseModel, nil)
            }
        }
    }
}
struct GETapplicationsettingsResponse: RawHTTPResponseWrapper {
    let settings: ApplicationSettingsStruct?
    let rawResponse: HTTPURLResponse?
    init(with json: Any?, rawResponse: HTTPURLResponse?) {
        self.rawResponse = rawResponse
        if let json = json as? [String: Any] {
            self.settings = ApplicationSettingsStruct(with: json["data"])
        } else {
            self.settings = nil
        }
    }
}
