//
//  ViewController.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/11/29//  Copyright © 2016年 dx lab. All rights reserved//

import UIKit
import HTTPIDL


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        BaseClientConfiguration.shared.baseURLString = "http://httpbin.org/"
        BaseClientConfiguration.shared.baseURLString = "http://img.171u.com/"
        let configuration = URLSessionConfiguration.default
        BaseClient.shared.clientImpl = NSClient(configuration: configuration, delegate: nil, delegateQueue: nil)
        
//        let request = PostTestMultipartEncoderRequest()
//        request.number = 123123123123
//        request.bool = false
//        request.string = "yellow submarine"
//        let dataString = "xxxxx"
//        let data = dataString.data(using: String.Encoding.utf8)!
//        request.data = HTTPData(with: data, fileName: "test_data", mimeType: "text/plain")
//        let url = Bundle.main.url(forResource: "China", withExtension: "png")!
//        request.file = HTTPFile(with: url, fileName: "test_file", mimeType: "image/png")
//        request.configuration.encoder = HTTPMultipartRequestEncoder.shared
//        request.send(completion: { (response) in
//            
//        }) { (error) in
//            
//        }
        
//        let request = PostTestJsonEncoderRequest()
//        request.t1 = 123123123123
//        request.t2 = 123
//        request.t3 = 1.1
//        request.t4 = "jude"
//        request.t5 = ["don't", "make", "it", "bad"]
//        request.send(HTTPJSONRequestEncoder.shared, responseDecoder: HTTPResponseJSONDecoder.shared, completion: { (response) in
//            
//        }, errorHandler: { (error) in
//            
//        })
        
//        let sticker = GetStickerMediaIdRequest(mediaId: "123123")
//        sticker.configuration.baseURLString = "http://api.everphoto.cn"
//        sticker.send(completion: { (response) in
//            print("sticker response: ", response)
//        }) { (error) in
//            print("sticker error: ", error)
//        }
//        let req = GetGetRequest()
//        req.configuration.callbackQueue = DispatchQueue.global()
//        req.int64 = 64
//        req.int32 = 32
//        req.bool = true
//        req.double = 3.1415926
//        req.string = "hey jude"
//        req.array = ["don't", "make", "it", "bad"]
//        req.send(completion: { (response) in
//            print("GetGetRequest resp: ", response)
//        }) { (error) in
//            print("GetGetRequest error: ", error)
//        }
        
//        let req = PostPostRequest()
//        req.configuration.encoder = HTTPMultipartRequestEncoder.shared
//        req.configuration.cachePolicy = CachePolicy.returnCacheDataDontLoad
//        let url = Bundle.main.url(forResource: "test", withExtension: "JPG")!
//        req.data = HTTPFile(with: url, fileName: "test_file", mimeType: "image/png")
//        let future = req.send(rawResponseHandler: { (response) in
//            print("resp: ", response)
//        }) { (error) in
//            print("fuck: ", error)
//        }
//        future.progressHandler = { p in
//            print("progress: ", p.fractionCompleted)
//        }
        
//        let req = PostFileRequest()
//        req.configuration.encoder = HTTPBinaryRequestEncoder.shared
//        let url = Bundle.main.url(forResource: "China", withExtension: "png")!
//        req.body = HTTPFile(with: url, fileName: "test_file", mimeType: "image/jpg")
//        let future = req.send(completion: { (response) in
//            
//        }) { (error) in
//            
//        }
        
//        let dataString = "xxxxx"
//        let data = dataString.data(using: String.Encoding.utf8)!
//        let req = PostDataRequest()
//        req.configuration.encoder = HTTPBinaryRequestEncoder.shared
//        req.body = HTTPData(with: data, fileName: "test_data", mimeType: "application/octet-stream")
//        let future = req.send(completion: { (response) in
//            
//        }) { (error) in
//            
//        }
        
//        let req = GetGetRequest()
//        req.configuration.decoder = HTTPResponseJSONDecoder()
//        req.send(completion: { (resp) in
//            debugPrint("resp", resp)
//        }) { (error) in
//            debugPrint("error", error)
//        }
        
//        let req = GetTestDownloadRequest()
//        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0].appending("/test.jpg")
//        debugPrint("filepath ", filePath)
//        req.configuration.decoder = HTTPResponseFileDecoder(filePath: filePath)
//        req.send(completion: { (resp) in
//            debugPrint("resp", resp)
//        }) { (error) in
//            debugPrint("error", error)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

