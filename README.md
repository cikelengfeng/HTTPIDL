# HTTPIDL
HTTPIDL is a collection of tools for type-safe HTTP networking and generating code from the specific IDL, it supports Swift 3/4.
HTTPIDL aims to help developer focus on the bussniss logic, cencern HTTP detail as less as possible(you have to know HTTP detail only when you need to extend HTTPIDL)

## Status
![UnitTest](https://img.shields.io/badge/test-passing-brightgreen.svg)   ![Cocoapods](https://img.shields.io/badge/pod-1.1.15-blue.svg)

## Feature
* Type-Safe
* Swift 3/4 code generator, handwritten code is also supported
* URL / JSON / URLEncodedForm request encoders（even combination of encoders is supported）
* Upload File / Data / MultipartFormData
* Convert JSON response body to Model object automatically (you can extend response decoder to support other response body type)
* Extendable request encoder
* Extendable response decoder
* Alternative HTTP client (default is NSURLSession)
* Observer for Request & Response
* Rewriter for Request & Response

## Requirements
* iOS 8.0 +
* Xcode 8.1 + 
* Swift 3 +
* python 2.7.x

*note: you can use version 1.1.9 in swift 3

## Installation
### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

`$ gem install cocoapods`

To integrate HTTPIDL into your Xcode project using CocoaPods, specify it in your Podfile:
```
use_frameworks!

target '<Your Target Name>' do
    pod 'HTTPIDL'
end
```

Then, run the following command:

`$ pod install`

## Get Started
### Generate request and response
create a text file named with example.http in /your/httpidl/directory, and write following code in it:
```
MESSAGE /my/example {
	GET REQUEST {
		INT32 t1 = t;
		STRING t2 = tt;
	}
	GET RESPONSE {
		INT64 x1 = x;
		DOUBLE x2 = xx;
	}
}
```

Then, run the following command：
`python Pods/HTTPIDL/Sources/Compiler/HTTPIDL.py -d /your/httpidl/directory -o /your/httpidl/idl_output`

Then, request and response code file is placed in /your/httpidl/idl_output, generate following code:
```
import Foundation
import HTTPIDL

class GetMyExampleRequest: Request {
    
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
        return "/my/example"
    }
    
    var t1: Int32?
    var t2: String?
    
    let keyOfT1 = "t"
    let keyOfT2 = "tt"
    var content: RequestContent? {
        var result = [String: RequestContent]()
        if let tmp = t1 {
            result["t"] = tmp.asRequestContent()
        }
        if let tmp = t2 {
            result["tt"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    
    @discardableResult
    func send(completion: @escaping (GetMyExampleResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<GetMyExampleResponse> {
        let future: RequestFuture<GetMyExampleResponse> = manager.send(self, responseHandler: completion, errorHandler: errorHandler, progressHandler: nil)
        return future
    }
    
    @discardableResult
    func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {
        let future = manager.send(self, responseHandler: completion, errorHandler: errorHandler, progressHandler: nil)
        return future
    }
}

struct GetMyExampleResponse: Response {
    
    let x1: Int64?
    let x2: Double?
    let rawResponse: HTTPResponse
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws {
        self.rawResponse = rawResponse
        guard let content = content, case .dictionary(let value) = content else {
            self.x1 = nil
            self.x2 = nil
            return
        }
        self.x1 = Int64(content: value["x"])
        self.x2 = Double(content: value["xx"])
    }
}
```


You can send HTTP request by following code:
```
import HTTPIDL

let request = GetMyExampleRequest()
request.t1 = 123
request.t2 = "while my guitar gently weeps"
request.send(completion: { (response) in
            //handle GetMyExampleResponse
        }) { (error) in
            //handle error
        }
```

### Handwritten request

In HTTPIDL, whether the generated code or handwritten code must conform to 'Request' Protocol:
```
public protocol Request {
    var method: String {get} //HTTP method
    var configuration: RequestConfiguration {get set} //configuration contains baseURLString, headers and so on
    var uri: String {get} //uri reference without scheme and host
    var content: RequestContent? {get} //http request body
}
```

Classes conform to 'Request' protocol can be sent by following code：
```
let request = //your handwritten request
request.configuration.encoder = URLEncodedQueryEncoder.shared
BaseRequestManager.shared.send(request)
```

Or you can use these simple methods below
```
HTTPIDL.get
HTTPIDL.getJSON
HTTPIDL.post
HTTPIDL.postJSON
HTTPIDL.delete
HTTPIDL.deleteJSON
HTTPIDL.put
HTTPIDL.putJSON
HTTPIDL.patch
HTTPIDL.patchJSON
HTTPIDL.send
String.download
URL.download
```

## Roadmap
1. Optimize Error Handling (version 1.2.0) 
2. Support Objective-C
3. More Support For HTTPS
4. Documentation
