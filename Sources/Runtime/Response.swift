//
//  Response.swift
//  Pods
//
//  Created by 徐 东 on 2017/8/17.
//
//

import Foundation

public protocol Response {
    init(content: ResponseContent?, rawResponse: HTTPResponse) throws
}
