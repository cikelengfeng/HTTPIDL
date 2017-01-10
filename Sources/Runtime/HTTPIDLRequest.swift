//
//  RequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/2.
//  Copyright © 2017年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct PlainRequest: Request {
    static var defaultMethod: String = "GET"
    var method: String
    var configuration: Configuration
    var uri: String
    var content: RequestContent?
    
    init(method: String, uri: String, configuration: Configuration, content: RequestContent?) {
        self.method = method
        self.configuration = configuration
        self.uri = uri
        self.content = content
    }
}
