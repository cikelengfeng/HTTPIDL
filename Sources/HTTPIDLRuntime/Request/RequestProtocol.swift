//
//  RequestProtocol.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

protocol HTTPParameter {
    var key: String {get}
    var value: () -> String {get}
}

protocol HTTPRequest {
    
    associatedtype Response
    
    var parameters: [HTTPParameter]? {get set}
    var headers: [String: String]? {get set}
    var url: URL {get set}
    
    func send() -> Response
}
