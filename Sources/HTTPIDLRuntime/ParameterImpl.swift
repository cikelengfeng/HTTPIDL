//
//  ParameterImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct IntegerParameter: HTTPIDLParameter {
    
    var key: String
    var rawValue: Int64
    var value: () throws -> String {
        get {
            return { String(self.rawValue) }
        }
    }
    
    init(with key: String, rawValue: Int64) {
        self.key = key
        self.rawValue = rawValue
    }
    
}

struct StringParameter: HTTPIDLParameter {
    var key: String
    var rawValue: String
    var value: () throws -> String {
        get {
            return { self.rawValue }
        }
    }
    
    init(with key: String, rawValue: String) {
        self.key = key
        self.rawValue = rawValue
    }
}


struct DoubleParameter: HTTPIDLParameter {
    var key: String
    var rawValue: Double
    var value: () throws -> String {
        get {
            return { String(self.rawValue) }
        }
    }
    
    init(with key: String, rawValue: Double) {
        self.key = key
        self.rawValue = rawValue
    }
}

struct FileParameter: HTTPIDLParameter {
    var key: String
    var url: URL
    var name: String
    var value: () throws -> String {
        get {
            return {
                let data = Data(contentsOf: self.url, options: Data.ReadingOptions.mappedIfSafe)
                return String(data: data, encoding: String.Encoding.utf8) ?? ""
            }
        }
    }
    
    init(with key: String, url: URL, fileName: String) {
        self.key = key
        self.url = url
        self.name = fileName
    }
}

struct DataParameter: HTTPIDLParameter {
    var key: String
    var data: Data
    var name: String
    var value: () throws -> String {
        get {
            return {
                return String(data: self.data, encoding: String.Encoding.utf8) ?? ""
            }
        }
    }
    
    init(with key: String, data: Data, fileName: String) {
        self.key = key
        self.data = data
        self.name = fileName
    }
}

