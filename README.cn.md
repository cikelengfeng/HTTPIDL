# HTTPIDL
HTTPIDL是一套类型安全的HTTP网络库和代码生成工具的集合，目前支持Swift 3。
HTTPIDL致力于帮助开发者将精力专注于业务逻辑，尽可能少的关心HTTP的相关细节（当然HTTPIDL也为一些特殊的需求预留了扩展的接口，实现这些需求可能需要开发者了解HTTP的细节）

## 状态
![UnitTest](https://img.shields.io/badge/test-passing-brightgreen.svg)   ![Cocoapods](https://img.shields.io/badge/pod-1.1.9-blue.svg)

## 特色
* 类型安全
* 自动生成swift 3/4代码，同时支持手写
* URL / JSON / URLEncodedForm 请求内容编码方式（甚至支持组合编码方式）
* 上传 File / Data / MultipartFormData
* JSON 响应内容自动转换为 Model
* 可扩展的请求内容编码器
* 可扩展的响应内容解码器
* 可扩展的HTTP客户端库
* 支持请求和响应观察者
* 支持请求和响应重写

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
    
    var method: String = "GET"
    private var _configuration: RequestConfiguration?
    var configuration: RequestConfiguration {
        get {
            guard let config = _configuration else {
                return BaseRequestConfiguration.create(from: client.configuration, request: self)
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


现在你可以这样发请求了: 
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

### 手写请求

在HTTPIDL中，无论自动生成还是手写的请求都要实现Request协议：
```
public protocol Request {
    var method: String {get} //此请求对象的method
    var configuration: RequestConfiguration {get set} //此请求对象的配置，包括baseURLString, headers
    var uri: String {get} //此请求对象的uri
    var content: RequestContent? {get} //此请求的内容，对应http request body
}
```

实现了Request协议的对象都可以使用以下代码发送：
```
let request = //your hand-writed request
request.configuration.encoder = URLEncodedQueryEncoder.shared
BaseClient.shared.send(request)
```

或者你可以使用下边这些简单的方法
`HTTPIDL.get`
`HTTPIDL.getJSON`
`HTTPIDL.post`
`HTTPIDL.postJSON`
`HTTPIDL.delete`
`HTTPIDL.deleteJSON`
`HTTPIDL.put`
`HTTPIDL.putJSON`
`HTTPIDL.patch`
`HTTPIDL.patchJSON`
`HTTPIDL.send`
`String.download`
`URL.download`

## 内置编码器
### URL Encoded Query 编码器
类名：URLEncodedQueryEncoder
此编码器会将请求的content属性加入到url的query中，例如有如下请求：
```
func test() {
	let request = GetMyExampleRequest()
	request.t1 = 123
	request.t2 = "hey"
	request.configuration.encoder = URLEncodedQueryEncoder.shared
	BaseClient.shared.send(request)
}
```


此请求最终发送的http request如下：
```
GET /my/example?t2=hey&t1=123 HTTP/1.1
Host: here.is.you.host
```

### URL Encoded Form 编码器
类名：URLEncodedFormEncoder
此编码器会将请求的content转换成request body中url encode编码的表单，例如有如下请求：
```
func test() {
	let request = PostMyExampleRequest()
	request.t1 = 123
	request.t2 = "hey"
	request.configuration.encoder = URLEncodedFormEncoder.shared
	BaseClient.shared.send(request)
}
```

此请求最终发送的http request如下：
```
POST /my/example HTTP/1.1
Host: here.is.you.host
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Content-Length: 13

t1=123&t2=hey
```

### JSON 编码器
类名：JSONEncoder
此编码器会将请求的content转换成request body中的JSON，例如有如下请求：
```
func test() {
	let request = PostTestJsonEncoderRequest()
    request.t1 = 123123123123
    request.t2 = 123
    request.t3 = 1.1
    request.t4 = "jude"
	request.t5 = ["don't", "make", "it", "bad"]
}
```

此请求最终发送的http request如下：
```
POST /test/json/encoder HTTP/1.1
Host: your.api.host
Content-Type: application/json
Content-Length: 87

{"ttt":1.1,"tttt":"jude","t":123123123123,"ttttt":["don't","make","it","bad"],"tt":123}
```

### Multipart 编码器
类名：MutlipartEncoder
此编码器会将请求的content转换成request body中的multipart form，例如有如下请求：
```
let request = PostTestMultipartEncoderRequest()
request.t1 = 123123123123
request.t2 = 123
request.t3 = 1.1
request.t4 = "jude"
let data = try! Data(contentsOf: Bundle.main.url(forResource: "test", withExtension: "JPG")!)
request.t5 = HTTPData(with: data, fileName: "test", mimeType: "image/jpeg")
request.configuration.encoder = MutlipartEncoder.shared
request.send(completion: { (response) in
    
}) { (error) in
    
}
```

此请求最终发送的http request如下：
```
POST /test/multipart/encoder HTTP/1.1
Host: your.api.host
Content-Type: multipart/form-data; boundary=httpidl.boundary.2ebcd6891b6c4c27
Content-Length: 186144

--httpidl.boundary.2ebcd6891b6c4c27
Content-Disposition: form-data; name="tt"

123
--httpidl.boundary.2ebcd6891b6c4c27
Content-Disposition: form-data; name="tttttt"; filename="test"
Content-Type: image/jpeg

<very long data>
--httpidl.boundary.2ebcd6891b6c4c27
Content-Disposition: form-data; name="tttt"

jude
--httpidl.boundary.2ebcd6891b6c4c27
Content-Disposition: form-data; name="t"

123123123123
--httpidl.boundary.2ebcd6891b6c4c27
Content-Disposition: form-data; name="ttt"

1.1
--httpidl.boundary.2ebcd6891b6c4c27--
```

## 内置解码器
### JSON 解码器
类名：JSONDecoder
此解码器会将response body 当做JSON 来解析成与之同构的ResponseContent

## 观察者（Observer）
观察者是一组由Client协议实现类管理的对象，他们需要实现RequestObserver 或 ResponseObserver协议：
```
public protocol RequestObserver: class {
    func willSend(request: Request)
    func didSend(request: Request)
    func willEncode(request: Request)
    func didEncode(request: Request, encoded: HTTPRequest)
}

public protocol ResponseObserver: class {
    func receive(error: HIError)
    func receive(rawResponse: HTTPResponse)
    func willDecode(rawResponse: HTTPResponse)
    func didDecode(rawResponse: HTTPResponse, decodedResponse: Response)
}
```

观察者可以在请求发送中的各个时间点接收到回调，在这些回调中可以做一些特殊逻辑，如：打印日志

## Rewriter
Rewriter是一组由Client协议实现类管理的对象，他们需要实现RequestRewriter 或 ResponseRewriter协议：
```
public enum RequestRewriterResult {
    case request(request: HTTPRequest)
    case response(response: HTTPResponse)
    case error(error: HIError)
}

public protocol RequestRewriter: class {
    func rewrite(request: HTTPRequest) -> RequestRewriterResult
}

public enum ResponseRewriterResult {
    case response(response: HTTPResponse)
    case error(error: HIError)
}

public protocol ResponseRewriter: class {
    func rewrite(response: HTTPResponse) -> ResponseRewriterResult
}
```

request rewriter可以将request重写成另一个request、 response 或 error

response rewriter可以将response重写成另一个response 或 error

## Roadmap
1. Optimize Error Handling (version 1.2.0) [Swift runtime]
2. More Support For HTTPS
3. Documentation
