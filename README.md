# HTTPIDL
HTTPIDL是一套HTTP网络库和代码生成工具的集合，目前支持Swift 3。

## 功能
* 自动生成swift 3代码，同时支持手写
* URL / JSON / URLEncodedForm 请求内容编码方式（甚至支持组合编码方式）
* 上传 File / Data / MultipartFormData
* JSON 响应内容自动转换为 Model
* 可扩展的请求内容编码器
* 可扩展的响应内容解码器
* 可扩展的HTTP客户端库 （默认使用Alamofire）
* 支持请求和响应观察者
* 支持请求和响应重写
* 单元测试

## 要求
* iOS 8.0 +
* Xcode 8.1 + 
* Swift 3 +
* python 2.7.x

## 安装
### CocoaPods
CocoaPods 是一个包管理器，你可以通过下面的命令安装它：
`$ gem install cocoapods`

在你的Podfile中添加以下代码，即可将HTTPIDL整合进你的项目:
```
use_frameworks!

target '<Your Target Name>' do
    pod 'HTTPIDL'
end
```

然后运行一下命令：
`$ pod install`

## 使用
### 自动生成请求与响应代码
在 /your/httpidl/directory 文件夹中创建一个扩展名为.http的文本文件，并在文件中添加以下代码:
```
MESSAGE /my/example {
	GET REQUEST {
		INT32 t1 = t;
		STRING t2 = tt;
		BOOL t3 = ttt;
	}
	GET RESPONSE {
		INT64 x1 = x;
		DOUBLE x2 = xx;
	}
}
```

然后执行以下命令来生成代码：
`python Pods/HTTPIDL/Sources/Compiler/HTTPIDL.py -d /your/httpidl/directory -o /your/httpidl/idl_output`

执行之后，会在/your/httpidl/idl_output 文件夹下生成如下样式的代码:
```
import Foundation
import HTTPIDL

class GetMyExampleRequest: Request {
    
    static let defaultMethod: String = "GET"
    var method: String = GetMyExampleRequest.defaultMethod
    var configuration: Configuration = BaseConfiguration.shared
    var client: Client = BaseClient.shared
    var uri: String {
        get {
            return "/my/example"
        }
    }
    var t1: Int32?
    var t2: String?
    var content: RequestContent? {
        var result = [String:RequestContent]()
        if let tmp = t1 {
            result["t"] = tmp.asRequestContent()
        }
        if let tmp = t2 {
            result["tt"] = tmp.asRequestContent()
        }
        return .dictionary(value: result)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetMyExampleRequest.defaultEncoder, responseDecoder: HTTPResponseDecoder = GetMyExampleResponse.defaultDecoder, completion: @escaping (GetMyExampleResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, responseDecoder: responseDecoder, completion: completion, errorHandler: errorHandler)
    }
    func send(_ requestEncoder: HTTPRequestEncoder = GetMyExampleRequest.defaultEncoder, rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (HIError) -> Void) {
        client.send(self, requestEncoder: requestEncoder, completion: rawResponseHandler, errorHandler: errorHandler)
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


现在你可以这样发请求了: 
```
import HTTPIDL

let request = GetMyExampleRequest()
request.send(completion: { (response) in
            //handle GetMyExampleResponse
        }) { (error) in
            //handle error
        }
```

### 手写请求

在HTTPIDL中，无论自动生成还是手写的请求都要实现Request协议：
```
public protocol Request {
    static var defaultMethod: String {get} //该类请求的默认method
    var method: String {get} //此请求对象的method
    var configuration: Configuration {get set} //此请求对象的配置，包括baseURLString, headers
    var uri: String {get} //此请求对象的uri
    var content: RequestContent? {get} //此请求的内容，对应http request body
}
```

实现了Request协议的对象都可以使用以下代码发送：
```
let request = //your hand-writed request
let requestEncoder = HTTPURLEncodedQueryRequestEncoder.shared
BaseClient.shared.send(request, requestEncoder: requestEncoder, completion: yourCompletionClosure, errorHandler: yourErrorHandler)
```


