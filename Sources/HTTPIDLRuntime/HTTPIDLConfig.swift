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

protocol HTTPIDLConfiguration {
    var baseURLString: String {get set}
    var parameterEncoding: ParameterEncoding {get set}
    var headers: HTTPHeaders? {get set}
    
    mutating func append(headers: HTTPHeaders)
}

public struct BaseHTTPIDLConfiguration: HTTPIDLConfiguration {
    public static var shared = BaseHTTPIDLConfiguration(with: HTTPIDLBaseURLString, parameterEncoding: HTTPIDLDefaultParameterEncoding)
    
    public var baseURLString: String
    public var parameterEncoding: ParameterEncoding
    public var headers: HTTPHeaders? = nil
    
    init(with baseURLString: String, parameterEncoding: ParameterEncoding) {
        self.baseURLString = baseURLString
        self.parameterEncoding = parameterEncoding
    }
    
    mutating func append(headers: HTTPHeaders) {
        let newHeader = headers.reduce(self.headers ?? [:], { (soFar, soGood) in
            var mutableSoFar = soFar
            mutableSoFar[soGood.0] = soGood.1
            return mutableSoFar
        })
        self.headers = newHeader
    }
}
