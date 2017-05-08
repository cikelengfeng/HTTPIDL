//
//  RequestImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2017/1/2//

import Foundation

struct PlainRequest: Request {
    var method: String
    var configuration: RequestConfiguration
    var uri: String
    var content: RequestContent?
    
    init(method: String, uri: String, configuration: RequestConfiguration, content: RequestContent?) {
        self.method = method
        self.configuration = configuration
        self.uri = uri
        self.content = content
    }
}
