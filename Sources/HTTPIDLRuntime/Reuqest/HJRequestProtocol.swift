//
//  HJRequest.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/24.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

protocol HJParameter {
    var value: String {get set}
    var key: String {get set}
}

protocol HJParameterEncoder {
    func encode(_ parameters: [HJParameter]) -> String
    func encode(_ request: HJRequest) -> URLRequest
}

protocol HJRequest {
    var method: String {get set}
    var url: URL {get set}
    var parameters: [HJParameter] {get set}
}

