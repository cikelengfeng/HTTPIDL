//
//  HTTPIDLDemoTests.swift
//  HTTPIDLDemoTests
//
//  Created by 徐 东 on 2017/1/11.
//  Copyright © 2017年 dx lab. All rights reserved.
//

import XCTest
import HTTPIDL

struct TestRequest: Request {
    public static var defaultMethod: String = "GET"
    var method: String = TestRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var uri: String = "/my/test"

    var content: RequestContent?
    
    init(content: RequestContent?) {
        self.content = content
    }
}

class HTTPIDLDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        BaseConfiguration.shared.baseURLString = "http://api.everphoto.cn"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testURLEncodedQueryRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let encoder = HTTPURLEncodedQueryRequestEncoder.shared
        var testRequest = TestRequest(content: RequestContent.int64(value: 12312312312321313))
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "url encode 不支持int64型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.int32(value: 12312313)
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "url encode 不支持int32型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.bool(value: false)
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "url encode 不支持bool型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.double(value: 0.22)
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "url encode 不支持double型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.string(value: "yyyy")
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "url encode 不支持string型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.file(value: URL(fileURLWithPath: "xxx"), fileName: nil, mimeType: "image/*")
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "url encode 不支持file型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.data(value: Data(), fileName: "xxx", mimeType: "image/jpeg")
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "url encode 不支持data型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.array(value: [RequestContent.int64(value: 12312312312321313)])
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "url encode 不支持array型的根参数")
        } catch _ {
        }
        
        let fileURL = URL(fileURLWithPath: "xxx")
        let dataString = "xxxxx"
        let data = dataString.data(using: String.Encoding.utf8)!
        testRequest.content = RequestContent.dictionary(value: [
                                                                "int32": RequestContent.int32(value: 123123),
                                                                "int64": RequestContent.int64(value: 12312312312312),
                                                                "bool": RequestContent.bool(value: true),
                                                                "double": RequestContent.double(value: 0.023131),
                                                                "string": RequestContent.string(value: "hey"),
                                                                "file": RequestContent.file(value: fileURL, fileName: nil, mimeType: "image/*"),
                                                                "data": RequestContent.data(value: data, fileName: "xxx", mimeType: "image/jpeg"),
                                                                "array": RequestContent.array(value: [
                                                                                                    RequestContent.int32(value: 123123),
                                                                                                    RequestContent.int64(value: 12312312312312),
                                                                                                    RequestContent.bool(value: true),
                                                                                                    RequestContent.double(value: 0.023131),
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
        let encoder = HTTPJSONRequestEncoder.shared
        
        var testRequest = TestRequest(content: RequestContent.int64(value: 12312312312321313))
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "json encode 不支持int64型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.int32(value: 12312313)
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "json encode 不支持int32型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.bool(value: false)
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "json encode 不支持bool型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.double(value: 0.22)
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "json encode 不支持double型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.string(value: "yyyy")
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "json encode 不支持string型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.file(value: URL(fileURLWithPath: "xxx"), fileName: nil, mimeType: "image/*")
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "json encode 不支持file型的根参数")
        } catch _ {
        }
        
        testRequest.content = RequestContent.data(value: Data(), fileName: "xxx", mimeType: "image/jpeg")
        do {
            let _ = try encoder.encode(testRequest)
            XCTAssert(false, "json encode 不支持data型的根参数")
        } catch _ {
        }
        
        
        let fileURL = URL(fileURLWithPath: "xxx")
        let dataString = "xxxxx"
        let data = dataString.data(using: String.Encoding.utf8)!
        
        testRequest.content = RequestContent.array(value: [
            RequestContent.int32(value: 123123),
            RequestContent.int64(value: 12312312312312),
            RequestContent.bool(value: true),
            RequestContent.double(value: 0.023131),
            RequestContent.string(value: "hey"),
            RequestContent.file(value: fileURL, fileName: nil, mimeType: "image/*"),
            RequestContent.data(value: data, fileName: "xxx", mimeType: "image/jpeg")
            ])
        
        do {
            let encoded = try encoder.encode(testRequest)
            
            
        }catch _ {
            XCTFail()
        }
    }
    
}
