//
//  HTTPIDLConfig.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/11/30.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let HTTPIDLBaseURLString = "https://api.everfilter.me"
fileprivate let HTTPIDLDefaultParameterEncoding = URLEncoding.default
fileprivate let HTTPIDLDefaultHeaders: HTTPHeaders? = nil

public struct HTTPIDLConfiguration {
    public static var shared = HTTPIDLConfiguration(with: HTTPIDLBaseURLString, parameterEncoding: HTTPIDLDefaultParameterEncoding, headers: HTTPIDLDefaultHeaders)
    
    public private(set) var baseURLString: String
    public private(set) var parameterEncoding: ParameterEncoding
    public private(set) var headers: HTTPHeaders?
    
    init(with baseURLString: String, parameterEncoding: ParameterEncoding, headers: HTTPHeaders?) {
        self.baseURLString = baseURLString
        self.parameterEncoding = parameterEncoding
        self.headers = headers
    }
    
    mutating func append(headers: HTTPHeaders) {
        let newHeader = headers.reduce(self.headers ?? [:], { (soFar, soGood) in
            var mutableSoFar = soFar
            mutableSoFar[soGood.0] = soGood.1
            return mutableSoFar
        })
        self.headers = newHeader
    }
    
    mutating func set(baseURLString: String) {
        self.baseURLString = baseURLString
    }
    
    mutating func set(parameterEncoding: ParameterEncoding) {
        self.parameterEncoding = parameterEncoding
    }
}
