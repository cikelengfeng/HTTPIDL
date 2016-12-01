//
//  ViewController.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/11/29.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let req = GetApplicationSettingsRequest()
//        
//        req.send { (response, err) in
//            guard response.isSucceed() else {
//                return
//            }
////            asdasdas
//        }
        
        guard let url = Bundle.main.url(forResource: "test", withExtension: "jpg") else {
            return
        }
//        let shinkai = PostFiltersShinkaiRequest()
        do {
            let _ = try Data(contentsOf: url)
            let req = PostFiltersShinkaiRequest()
            req.baseURLString = "http://api.everphoto.me"
            req.image = url
            req.prepare { (encodeResult) in
                switch encodeResult {
                    case .success(let upload, _, _):
                        upload.responseData(completionHandler: { response in
                            guard let data = response.data, let image = UIImage(data: data) else {
                                return
                            }
                        })
                    case .failure(let encodingError):
                        print(encodingError)
                }
            }
        }catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

