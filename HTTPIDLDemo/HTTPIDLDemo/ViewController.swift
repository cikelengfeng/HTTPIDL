//
//  ViewController.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/11/29//  Copyright © 2016年 dx lab. All rights reserved//

import UIKit
import Alamofire
import HTTPIDL


class TestObserver: HTTPResponseObserver {
    func receive(error: HIError, request: HTTPIDL.Request) {
        
    }
    func receive(rawResponse: HTTPResponse) {
        
    }
    func willDecode(rawResponse: HTTPResponse) {
        guard let body = rawResponse.body else {
            return
        }
        
        let jsonString = String(data: body, encoding: String.Encoding.utf8)
        debugPrint("response is", jsonString ?? "fuck")
    }
    func didDecode(rawResponse: HTTPResponse, decodedResponse: Response) {
        
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        BaseConfiguration.shared.baseURLString = "https://httpbin.org/"
//        BaseClient.shared.add(responseObserver: TestObserver())
        
//        let request = PostTestMultipartEncoderRequest()
//        request.number = 123123123123
//        request.bool = false
//        request.string = "yellow submarine"
//        let dataString = "xxxxx"
//        let data = dataString.data(using: String.Encoding.utf8)!
//        request.data = HTTPData(with: data, fileName: "test_data", mimeType: "text/plain")
//        let url = Bundle.main.url(forResource: "China", withExtension: "png")!
//        request.file = HTTPFile(with: url, fileName: "test_file", mimeType: "image/png")
//        request.send(HTTPMultipartRequestEncoder.shared, rawResponseHandler: { (response) in
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
        
        let sticker = GetStickerMediaIdRequest(mediaId: "123123")
        sticker.configuration.baseURLString = "http://api.everphoto.cn"
        sticker.send(completion: { (response) in
            print("sticker response: ", response)
        }) { (error) in
            print("sticker error: ", error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

