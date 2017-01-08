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
        BaseHTTPIDLConfiguration.shared.baseURLString = "http://api.everphoto.cn/"
        
        let req = GetApplicationSettingsRequest()
        req.send(completion: { (response) in
            print(response)
        }) { (error) in
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

