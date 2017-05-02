//
//  CustomType.swift
//  EverPhoto
//
//  Created by 徐 东 on 2017/2/16.
//  Copyright © 2017年 bytedance. All rights reserved.
//

import Foundation
import HTTPIDL

extension URL: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content, case .string(let value) = content, let url = URL(string: value) else {
            return nil
        }
        self = url
    }
}

extension URL: RequestContentConvertible {
    public func asRequestContent() -> RequestContent {
        return .string(value: absoluteString)
    }
}

public let standardFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.locale = Locale(identifier: "en_US")
    return formatter
}()

extension Date {
    public static func date(from standardString: String) -> Date? {
        return standardFormatter.date(from:standardString)
    }
    public func standardString() -> String {
        return standardFormatter.string(from: self)
    }
}

extension Date: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content, case .string(let value) = content, let date = Date.date(from: value) else {
            return nil
        }
        self = date
    }
}

extension Date: RequestContentConvertible {
    public func asRequestContent() -> RequestContent {
        return .string(value: standardString())
    }
}
