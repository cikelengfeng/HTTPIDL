//
//  HTTPIDLExtension.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/12/1.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import Foundation

extension RawHTTPResponseWrapper {
    func isSucceed() -> Bool {
        guard let raw = rawResponse else {
            return false
        }
        return raw.statusCode == 200
    }
}
