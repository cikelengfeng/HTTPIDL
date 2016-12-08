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
    
    let baseURLString: String
    let parameterEncoding: ParameterEncoding
    let headers: HTTPHeaders?
    
    init(with baseURLString: String, parameterEncoding: ParameterEncoding, headers: HTTPHeaders?) {
        self.baseURLString = baseURLString
        self.parameterEncoding = parameterEncoding
        self.headers = headers
    }
    
    mutating func append(headers: HTTPHeaders) -> HTTPIDLConfiguration {
        let newHeader = headers.reduce(self.headers ?? [:], { (soFar, soGood) in
            var mutableSoFar = soFar
            mutableSoFar[soGood.0] = soGood.1
            return mutableSoFar
        })
        return HTTPIDLConfiguration(with: self.baseURLString, parameterEncoding: self.parameterEncoding, headers: newHeader)
    }
    
    mutating func set(baseURLString: String) -> HTTPIDLConfiguration {
        return HTTPIDLConfiguration(with: baseURLString, parameterEncoding: self.parameterEncoding, headers: self.headers)
    }
    
    mutating func set(parameterEncoding: ParameterEncoding) -> HTTPIDLConfiguration {
        return HTTPIDLConfiguration(with: self.baseURLString, parameterEncoding: parameterEncoding, headers: self.headers)
    }
}
