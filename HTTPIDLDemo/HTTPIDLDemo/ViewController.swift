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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        BaseConfiguration.shared.baseURLString = "http://your.api.host/"
        
//        let request = PostTestMultipartEncoderRequest()
//        request.t1 = 123123123123
//        request.t2 = 123
//        request.t3 = 1.1
//        request.t4 = "jude"
//        let data = UIImagePNGRepresentation(UIImage(named: "China")!)!
//        request.t5 = HTTPData(with: data, fileName: "test", mimeType: "image/png")
//        request.send(HTTPMultipartRequestEncoder.shared, responseDecoder: HTTPResponseJSONDecoder.shared, completion: { (response) in
//            
//        }) { (error) in
//            debugPrint("error :", error)
//        }
        
        let request = PostTestJsonEncoderRequest()
        request.t1 = 123123123123
        request.t2 = 123
        request.t3 = 1.1
        request.t4 = "jude"
        request.t5 = ["don't", "make", "it", "bad"]
        request.send(HTTPJSONRequestEncoder.shared, responseDecoder: HTTPResponseJSONDecoder.shared, completion: { (response) in
            
        }, errorHandler: { (error) in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

