//
//  Error.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/5.
//
//

import Foundation

public protocol HTTPIDLError: Error {
    var message: String {get}
}
