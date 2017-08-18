//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！

import Foundation
import HTTPIDL

class GetApplicationSettingsRequest: Request {
    
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
        return "/application/settings"
    }
    
    var cpu: Int32?
    var totalMemory: Int64?
    var availableMemory: Int64?
    var resolution: String?
    
    let keyOfCpu = "cpu"
    let keyOfTotalMemory = "total_mem"
    let keyOfAvailableMemory = "avail_mem"
    let keyOfResolution = "resolution"
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = cpu {
            result["cpu"] = tmp.asRequestContent()
        }
        if let tmp = totalMemory {
            result["total_mem"] = tmp.asRequestContent()
        }
        if let tmp = availableMemory {
            result["avail_mem"] = tmp.asRequestContent()
        }
        if let tmp = resolution {
            result["resolution"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetApplicationSettingsResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetApplicationSettingsResponse> {
        let future: RequestFuture<GetApplicationSettingsResponse> = manager.send(self, responseHandler: completion, errorHandler: errorHandler, progressHandler: nil)
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = manager.send(self, responseHandler: rawResponseHandler, errorHandler: errorHandler, progressHandler: nil)
        return future
    }
}

struct GetApplicationSettingsResponse: Response {
    
    let code: Int32?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.code = nil
            return
        }
        self.code = Int32(content: value["code"])
    }
}
