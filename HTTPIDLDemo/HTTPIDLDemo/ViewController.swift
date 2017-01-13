//
//  ViewController.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/11/29.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import UIKit
import Alamofire
import HTTPIDL


class TestObserver: HTTPResponseObserver {
    func receive(error: HIError) {
        
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
        BaseConfiguration.shared.baseURLString = "https://api.everphoto.cn/"
        BaseClient.shared.add(responseObserver: TestObserver())
        
        let request = PostTestMultipartEncoderRequest()
        request.t1 = 123123123123
        request.t2 = 123
        request.t3 = 1.1
        request.t4 = "jude"
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "test", withExtension: "JPG")!)
        request.t5 = HTTPData(with: data, fileName: "test", mimeType: "image/jpeg")
        request.send(HTTPMultipartRequestEncoder.shared, responseDecoder: HTTPResponseJSONDecoder.shared, completion: { (response) in
            
        }) { (error) in
            
        }
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

