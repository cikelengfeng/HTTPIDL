//
//  Test.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct TestResponse: HTTPIDLResponse, CustomDebugStringConvertible {
    var decoder: HTTPResponseBodyJSONDecoder = HTTPResponseBodyJSONDecoder()
    var json: Any?
    init(with httpResponse: HTTPResponse) throws {
        guard let httpBody = httpResponse.body else {
            json = nil
            return
        }
        json = try decoder.decode(httpBody)
    }
    
    var debugDescription: String {
        get {
            return "\(json)"
        }
    }
}

struct TestGetRequest: HTTPIDLRequest {
    var method: String = "GET"
    var configration: HTTPIDLConfiguration = BaseHTTPIDLConfiguration.shared
    var client: HTTPIDLClient = HTTPIDLBaseClient()
    
    var uri: String = "/application/settings"
    var parameters: [HTTPIDLParameter] = []
    
    func send(_ requestEncoder: HTTPRequestEncoder = HTTPBaseRequestEncoder.shared, completion: @escaping (TestResponse?, Error?) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: completion)
    }
}

struct TestJSONRequest: HTTPIDLRequest {
    var method: String = "POST"
    var configration: HTTPIDLConfiguration = BaseHTTPIDLConfiguration.shared
    var client: HTTPIDLClient = HTTPIDLBaseClient()
    
    var uri: String = "/application/logs"
    var parameters: [HTTPIDLParameter] {
        get {
            return [IntegerParameter(with: "ttttt", rawValue: 1000222), StringParameter(with: "str", rawValue: "testing")]
        }
    }
    
    func send(_ requestEncoder: HTTPRequestEncoder = HTTPJSONRequestEncoder.shared, completion: @escaping (TestResponse?, Error?) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: completion)
    }
}

struct TestMultipartRequest: HTTPIDLRequest {
    var method: String = "POST"
    var configration: HTTPIDLConfiguration = BaseHTTPIDLConfiguration.shared
    var client: HTTPIDLClient = HTTPIDLBaseClient()
    
    var uri: String = "/filters/comic/v1"
    var parameters: [HTTPIDLParameter] {
        get {
            let imageData = UIImageJPEGRepresentation(UIImage(named: "nightActive")!, 0.8)!
            let dataParam = DataParameter(with: "media", data: imageData, fileName: "testing", mimeType: "image/*")
            let dataMD5 = imageData.md5().toHexString()
            let validationMD5 = (dataMD5 + "c222a8a3d0775498432b835f5445c2b4").md5()
            return [StringParameter(with: "token", rawValue: validationMD5), dataParam]
        }
    }
    
    func send(_ requestEncoder: HTTPRequestEncoder = HTTPMultipartRequestEncoder.shared, completion: @escaping (TestResponse?, Error?) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: completion)
    }
}
