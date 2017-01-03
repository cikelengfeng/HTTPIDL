//
//  HTTPIDLRequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/2.
//  Copyright © 2017年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct HTTPIDLPlainRequest: HTTPIDLRequest {
    static var defaultMethod: String = "GET"
    var method: String
    var configuration: HTTPIDLConfiguration
    var uri: String
    var parameters: [HTTPIDLParameter]
    
    init(method: String, uri: String, configuration: HTTPIDLConfiguration, parameters: [HTTPIDLParameter]) {
        self.method = method
        self.configuration = configuration
        self.uri = uri
        self.parameters = parameters
    }
}
