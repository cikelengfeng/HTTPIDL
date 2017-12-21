//
//  HTTPIDLDemoTests.swift
//  HTTPIDLDemoTests
//
//  Created by 徐 东 on 2017/1/11//  Copyright © 2017年 dx lab. All rights reserved//

import XCTest
import HTTPIDL

struct TestRequest: Request {
    public static var defaultMethod: String = "GET"
    var method: String = TestRequest.defaultMethod
    var _config: RequestConfiguration?
    var configuration: RequestConfiguration {
        get {
            guard let config = _config else {
                return BaseRequestConfiguration.create(from: BaseRequestManagerConfiguration.shared, request: self)
            }
            return config
        }
        set {
            _config = newValue
        }
    }
    var uri: String = "/my/test"

    var content: RequestContent?
    
    init(content: RequestContent?) {
        self.content = content
    }
}

struct TestHTTPRequest: HTTPRequest {
    var chunkedTransfer: Bool?
    
    static let stub = TestHTTPRequest(method: "GET", url: URL(fileURLWithPath: "xxxx"), headers: [:], bodyStream: nil)
    
    var method: String
    var headers: [String: String]
    var url: URL
    var bodyStream: InputStream?
    var cachePolicy: URLRequest.CachePolicy?
    var networkServiceType: URLRequest.NetworkServiceType?
    var timeoutInterval: TimeInterval?
    var shouldUsePipelining: Bool?
    var shouldHandleCookies: Bool?
    var allowsCellularAccess: Bool?
    
    init(method: String, url: URL, headers: [String: String], bodyStream: InputStream?) {
        self.method = method
        self.url = url
        self.headers = headers
        self.bodyStream = bodyStream
    }
}

struct TestResponse: HTTPResponse {
    var bodyStream: OutputStream?

    
    static let empty = TestResponse(statusCode: 200, headers: [:], bodyStream: nil, request: TestHTTPRequest.stub)
    
    var statusCode: Int
    var headers: [String: String]
    var request: HTTPRequest
    
    init(statusCode: Int, headers: [String: String], bodyStream: OutputStream?, request: HTTPRequest) {
        self.statusCode = statusCode
        self.headers = headers
        self.bodyStream = bodyStream
        self.request = request
    }
}

class HTTPIDLDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        BaseRequestManagerConfiguration.shared.baseURLString = "http://api.everphoto.cn"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testURLEncodedQueryRequest() {
        let encoder = URLEncodedQueryEncoder.shared
        var testRequest = TestRequest(content: RequestContent.number(value: 12312312312321313))
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("url encode 不支持int64型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 12312313)
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("url encode 不支持int32型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: false)
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("url encode 不支持bool型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 0.22)
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("url encode 不支持double型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.string(value: "yyyy")
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("url encode 不支持string型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.file(value: URL(fileURLWithPath: "xxx"), fileName: nil, mimeType: "image/*")
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("url encode 不支持file型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.data(value: Data(), fileName: "xxx", mimeType: "image/jpeg")
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("url encode 不支持data型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.array(value: [RequestContent.number(value: 12312312312321313)])
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("url encode 不支持array型的根参数")
        } catch _ {
        }
        
        let fileURL = URL(fileURLWithPath: "xxx")
        let dataString = "xxxxx"
        let data = dataString.data(using: String.Encoding.utf8)!
        testRequest.content = RequestContent.dictionary(value: [
                                                                "int32": RequestContent.number(value: 123123),
                                                                "int64": RequestContent.number(value: 12312312312312),
                                                                "bool": RequestContent.number(value: true),
                                                                "double": RequestContent.number(value: 0.023131),
                                                                "string": RequestContent.string(value: "hey"),
                                                                "file": RequestContent.file(value: fileURL, fileName: nil, mimeType: "image/*"),
                                                                "data": RequestContent.data(value: data, fileName: "xxx", mimeType: "image/jpeg"),
                                                                "array": RequestContent.array(value: [
                                                                                                    RequestContent.number(value: 123123),
                                                                                                    RequestContent.number(value: 12312312312312),
                                                                                                    RequestContent.number(value: true),
                                                                                                    RequestContent.number(value: 0.023131),
                                                                                                    RequestContent.string(value: "hey"),
                                                                                                    RequestContent.file(value: fileURL, fileName: nil, mimeType: "image/*"),
                                                                                                    RequestContent.data(value: data, fileName: "xxx", mimeType: "image/jpeg")
                                                                    ])
            ])
        do {
            let encoded = try encoder.encode(testRequest)
            guard let int32 = encoded.url.obtainFirstQuery(for: "int32") else {
                XCTFail()
                return
            }
            XCTAssert(int32 == "123123")
            
            guard let int64 = encoded.url.obtainFirstQuery(for: "int64") else {
                XCTFail()
                return
            }
            XCTAssert(int64 == "12312312312312")
            
            guard let bool = encoded.url.obtainFirstQuery(for: "bool") else {
                XCTFail()
                return
            }
            XCTAssert(bool == "1")
            
            guard let double = encoded.url.obtainFirstQuery(for: "double") else {
                XCTFail()
                return
            }
            XCTAssert(double == "0.023131")
            
            guard let string = encoded.url.obtainFirstQuery(for: "string") else {
                XCTFail()
                return
            }
            XCTAssert(string == "hey")
            
            guard let file = encoded.url.obtainFirstQuery(for: "file") else {
                XCTFail()
                return
            }
            XCTAssert(file == fileURL.absoluteString)
            
            guard let data = encoded.url.obtainFirstQuery(for: "data") else {
                XCTFail()
                return
            }
            XCTAssert(data == dataString)
            
            let array = encoded.url.obtainQuery(for: "array")
            XCTAssert(array[0] == "123123")
            XCTAssert(array[1] == "12312312312312")
            XCTAssert(array[2] == "1")
            XCTAssert(array[3] == "0.023131")
            XCTAssert(array[4] == "hey")
            XCTAssert(array[5] == fileURL.absoluteString)
            XCTAssert(array[6] == dataString)
            
        } catch _ {
            XCTFail()
        }
    }
    
    func testJSONEncoder() {
        let encoder = JSONEncoder.shared
        
        var testRequest = TestRequest(content: RequestContent.number(value: 12312312312321313))
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("json encode 不支持int64型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 12312313)
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("json encode 不支持int32型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: false)
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("json encode 不支持bool型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 0.22)
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("json encode 不支持double型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.string(value: "yyyy")
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("json encode 不支持string型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.file(value: URL(fileURLWithPath: "xxx"), fileName: nil, mimeType: "image/*")
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("json encode 不支持file型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.data(value: Data(), fileName: "xxx", mimeType: "image/jpeg")
        do {
            let _ = try encoder.encode(testRequest)
            XCTFail("json encode 不支持data型的根参数")
        } catch _ {
        }
        
        
        testRequest.content = RequestContent.array(value: [
            RequestContent.number(value: 123123),
            RequestContent.number(value: 12312312312312),
            RequestContent.number(value: true),
            RequestContent.number(value: 0.023131),
            RequestContent.string(value: "hey")
            ])
        
        do {
            let encoded = try encoder.encode(testRequest)
            let jsonObject = try JSONSerialization.jsonObject(with: encoded.bodyStream!.data(), options: .allowFragments)
            
            guard let array = jsonObject as? [Any] else {
                XCTFail()
                return
            }
            guard let int32 = array[0] as? Int32, int32 == 123123 else {
                XCTFail()
                return
            }
            guard let int64 = array[1] as? Int64, int64 == 12312312312312 else {
                XCTFail()
                return
            }
            guard let bool = array[2] as? Bool, bool else {
                XCTFail()
                return
            }
            
            guard let double = array[3] as? Double, double == 0.023131 else {
                XCTFail()
                return
            }
            
            guard let string = array[4] as? String, string == "hey" else {
                XCTFail()
                return
            }
            
        }catch _ {
            XCTFail()
        }
    }
    
    func testURLEncodedFormEncoder() {
        let encoder = URLEncodedFormEncoder.shared
        var testRequest = TestRequest(content: RequestContent.number(value: 12312312312321313))
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("url encode 不支持int64型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 12312313)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("url encode 不支持int32型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: false)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("url encode 不支持bool型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 0.22)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("url encode 不支持double型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.string(value: "yyyy")
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("url encode 不支持string型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.file(value: URL(fileURLWithPath: "xxx"), fileName: nil, mimeType: "image/*")
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("url encode 不支持file型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.data(value: Data(), fileName: "xxx", mimeType: "image/jpeg")
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("url encode 不支持data型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.array(value: [RequestContent.number(value: 12312312312321313)])
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("url encode 不支持array型的根参数")
        } catch _ {
        }
        
        let fileURL = URL(fileURLWithPath: "xxx")
        let dataString = "xxxxx"
        let data = dataString.data(using: String.Encoding.utf8)!
        testRequest.content = RequestContent.dictionary(value: [
            "int32": RequestContent.number(value: 123123),
            "int64": RequestContent.number(value: 12312312312312),
            "bool": RequestContent.number(value: true),
            "double": RequestContent.number(value: 0.023131),
            "string": RequestContent.string(value: "hey"),
            "string1": RequestContent.string(value: "hey+jude"),
            "file": RequestContent.file(value: fileURL, fileName: nil, mimeType: "image/*"),
            "data": RequestContent.data(value: data, fileName: "xxx", mimeType: "image/jpeg"),
            "array": RequestContent.array(value: [
                RequestContent.number(value: 123123),
                RequestContent.number(value: 12312312312312),
                RequestContent.number(value: true),
                RequestContent.number(value: 0.023131),
                RequestContent.string(value: "hey"),
                RequestContent.file(value: fileURL, fileName: nil, mimeType: "image/*"),
                RequestContent.data(value: data, fileName: "xxx", mimeType: "image/jpeg")
                ])
            ])
        do {
            let encoded = try encoder.encode(testRequest)
            let formData = encoded.bodyStream!.data()
            let formString = String(data: formData, encoding: String.Encoding.utf8)!
            let formPairs = formString.components(separatedBy: "&").map({ (kvString) -> (String, String) in
                let components = kvString.components(separatedBy: "=")
                return (components[0], components[1])
            })
            let formDict = formPairs.reduce([String: Any](), { (soFar, soGood) in
                var ret = soFar
                if let exists = ret[soGood.0] {
                    var arr = [soGood.1]
                    if let exists = exists as? [String] {
                        ret[soGood.0] = exists + arr
                    } else if let exists = exists as? String {
                        arr.insert(exists, at: 0)
                        ret[soGood.0] = arr
                    }
                } else {
                    ret[soGood.0] = soGood.1
                }
                return ret
            })
            
            guard let int32 = formDict["int32"] as? String else {
                XCTFail()
                return
            }
            XCTAssert(int32 == "123123")
            
            guard let int64 = formDict["int64"] as? String else {
                XCTFail()
                return
            }
            XCTAssert(int64 == "12312312312312")
            
            guard let double = formDict["double"] as? String else {
                XCTFail()
                return
            }
            XCTAssert(double == "0.023131")
            
            guard let string = formDict["string"] as? String else {
                XCTFail()
                return
            }
            XCTAssert(string == "hey")
            guard let string1 = formDict["string1"] as? String else {
                XCTFail()
                return
            }
            XCTAssert(string1 == "hey%2Bjude")
            
            guard let file = formDict["file"] as? String else {
                XCTFail()
                return
            }
            XCTAssert(file == fileURL.absoluteString)
            
            guard let data = formDict["data"] as? String else {
                XCTFail()
                return
            }
            XCTAssert(data == dataString)
            
            guard let array = formDict["array"] as? [String] else {
                XCTFail()
                return
            }
            XCTAssert(array[0] == "123123")
            XCTAssert(array[1] == "12312312312312")
            XCTAssert(array[2] == "1")
            XCTAssert(array[3] == "0.023131")
            XCTAssert(array[4] == "hey")
            XCTAssert(array[5] == fileURL.absoluteString)
            XCTAssert(array[6] == dataString)
            
        } catch _ {
            XCTFail()
        }
    }
    
    func testJSONDecoder() {
        
        let decoder = HTTPIDL.JSONDecoder()
        let jsonDict: [String : Any] = ["number": 123, "bool": true, "string": "hey jude", "array": [1, 2], "dict": ["foo": "bar"]]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        let outputStream = decoder.outputStream!
        outputStream.open()
        try! jsonData.writeTo(stream: outputStream)
        outputStream.close()
        let testResponse = TestResponse(statusCode: 200, headers: [:], bodyStream: outputStream, request: TestHTTPRequest.stub)
        do {
            guard let responseContent = try decoder.decode(testResponse) else {
                XCTFail()
                return
            }
            guard case .dictionary(let dict) = responseContent else {
                XCTFail()
                return
            }
            guard let number = dict["number"], case .number(let intValue) = number, intValue == 123 else {
                XCTFail()
                return
            }
            
            guard let bool = dict["bool"], case .number(let boolValue) = bool, boolValue.boolValue else {
                XCTFail()
                return
            }
            guard let string = dict["string"], case .string(let stringValue) = string, stringValue == "hey jude" else {
                XCTFail()
                return
            }
            
            guard let array = dict["array"], case .array(let arrayValue) = array else {
                XCTFail()
                return
            }
            guard case .number(let intInArr0) = arrayValue[0], intInArr0 == 1 else {
                XCTFail()
                return
            }
            guard case .number(let intInArr1) = arrayValue[1], intInArr1 == 2 else {
                XCTFail()
                return
            }
            
            guard let innerDict = dict["dict"], case .dictionary(let dictValue) = innerDict else {
                XCTFail()
                return
            }
            guard let foo = dictValue["foo"] else {
                XCTFail()
                return
            }
            
            guard case .string(let bar) = foo, bar == "bar" else {
                XCTFail()
                return
            }
            
        } catch _ {
            XCTFail()
        }
    }
    
    func testMultipartFormEncoder() {
        let encoder = MultipartEncoder.shared
        var testRequest = TestRequest(content: RequestContent.number(value: 12312312312321313))
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持int64型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 12312313)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持int32型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: false)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持bool型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 0.22)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持double型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.string(value: "yyyy")
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持string型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.file(value: URL(fileURLWithPath: "xxx"), fileName: nil, mimeType: "image/*")
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持file型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.data(value: Data(), fileName: "xxx", mimeType: "image/jpeg")
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持data型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.array(value: [RequestContent.number(value: 12312312312321313)])
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持array型的根参数")
        } catch _ {
        }
        
        let dataString = "xxxxx"
        let data = dataString.data(using: String.Encoding.utf8)!
        testRequest.content = RequestContent.dictionary(value: [
                        "number": RequestContent.number(value: 123123123123),
                        "bool": RequestContent.number(value: false),
                        "string": RequestContent.string(value: "yellow submarine"),
                        "file": RequestContent.file(value: Bundle.main.url(forResource: "China", withExtension: "png")!, fileName: "test_file", mimeType: "image/png"),
                        "data": RequestContent.data(value: data, fileName: "test_data", mimeType: "text/plain")
                        ])
        do {
            let encoded = try encoder.encode(testRequest)
            let body = encoded.bodyStream!.data()
            XCTAssert(body.count == 46929)
        } catch _ {
            XCTFail()
        }
    }
        
    func testBinaryEncoder() {
        let encoder = BinaryEncoder.shared
        var testRequest = TestRequest(content: RequestContent.number(value: 12312312312321313))
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("binary encode 不支持int64型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 12312313)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("binary encode 不支持int32型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: false)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("binary encode 不支持bool型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.number(value: 0.22)
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("binary encode 不支持double型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.string(value: "yyyy")
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("binary encode 不支持string型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.array(value: [RequestContent.number(value: 12312312312321313)])
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持array型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.dictionary(value: ["xxx": RequestContent.number(value: 12312312312321313)])
        do {
            let _ = try encoder.encode(testRequest).bodyStream!.data()
            XCTFail("multipart encode 不支持dictionary型的根参数")
        } catch _ {
        }
        
        let url = Bundle.main.url(forResource: "China", withExtension: "png")!
        testRequest.content = RequestContent.file(value: url, fileName: "test_file", mimeType: "image/png")
        do {
            let encoded = try encoder.encode(testRequest)
            let body = encoded.bodyStream!.data()
            let data = try! Data(contentsOf: url)
            XCTAssert(body.count == data.count)
        } catch _ {
            XCTFail()
        }
        let dataString = "xxxxx"
        let data = dataString.data(using: String.Encoding.utf8)!
        testRequest.content = RequestContent.data(value: data, fileName: "test_data", mimeType: "text/plain")
        do {
            let encoded = try encoder.encode(testRequest)
            let body = encoded.bodyStream!.data()
            XCTAssert(body.count == 5)
        } catch _ {
            XCTFail()
        }
    }
}
