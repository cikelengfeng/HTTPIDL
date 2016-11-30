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
        let req = GETapplicationsettingsRequest()
        req.test = 12345
        req.send { (response, err) in
            guard let settings = response?.settings else {
                print(err ?? "no error, no settings")
                return
            }
            print(settings.smsCode ?? "no feedback info")
            print(settings.tagVersion ?? "no tag version")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

