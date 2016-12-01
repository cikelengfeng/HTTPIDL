//
//  JSONConvertor.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2016/11/30.
//  Copyright © 2016年 dx lab. All rights reserved.
//

import Foundation

public protocol JSONObject {
    init?(with json: Any?)
}

struct MultipartFile {
    let key: String
    let fileURL: URL
    
    init(with key: String, url: URL) {
        self.key = key
        self.fileURL = url
    }
}

extension Int32: JSONObject {
    public init?(with json: Any?) {
        if let int = json as? Int32 {
            self.init(int)
            return
        }
        if let str = json as? String {
            self.init(str)
            return
        }
        return nil
    }
}

extension Int64: JSONObject {
    public init?(with json: Any?) {
        if let int = json as? Int64 {
            self.init(int)
            return
        }
        if let str = json as? String {
            self.init(str)
            return
        }
        return nil
    }
}

extension Double: JSONObject {
    public init?(with json: Any?) {
        if let number = json as? Double {
            self.init(number)
            return
        }
        if let str = json as? String {
            self.init(str)
            return
        }
        return nil
    }
}

extension String: JSONObject {
    public init?(with json: Any?) {
        if let str = json as? String {
            self.init(str)
            return
        }
        return nil
    }
}
