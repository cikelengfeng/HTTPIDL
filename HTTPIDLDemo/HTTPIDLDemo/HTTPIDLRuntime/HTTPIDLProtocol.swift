//
//  HTTPIDLProtocol.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/12/1.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import Foundation

protocol RawHTTPResponseWrapper {
    var rawResponse: HTTPURLResponse? {get}
}
