//
//  HTTPIDLConfig.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/11/30.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import Foundation
import Alamofire

fileprivate var HTTPIDLBaseURLString = "http://api.everphoto.cn"
fileprivate var HTTPIDLDefaultParameterEncoding = URLEncoding.default
fileprivate var HTTPIDLDefaultHeaders: HTTPHeaders? = nil

public struct HTTPIDLConfiguration {
    public static var shared = HTTPIDLConfiguration(with: HTTPIDLBaseURLString, parameterEncoding: HTTPIDLDefaultParameterEncoding, headers: HTTPIDLDefaultHeaders)
    
    let baseURLString: String
    let parameterEncoding: ParameterEncoding
    let headers: HTTPHeaders?
    
    init(with baseURLString: String, parameterEncoding: ParameterEncoding, headers: HTTPHeaders?) {
        self.baseURLString = baseURLString
        self.parameterEncoding = parameterEncoding
        self.headers = headers
    }
}
