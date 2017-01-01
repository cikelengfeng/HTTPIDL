//
//  ParameterImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/28.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

enum HTTPIDLParameterEncodeError: Error {
    case EncodeToStringFailed
}

struct IntegerParameter: HTTPIDLParameter {
    
    var key: String
    var rawValue: Int64
    var fileName: String? = nil
    var mimeType: String? = nil
    var value: () throws -> Data {
        get {
            return {
                guard let data = String(self.rawValue).data(using: String.Encoding.utf8) else {
                    throw HTTPIDLParameterEncodeError.EncodeToStringFailed
                }
                return data
            }
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
    var fileName: String? = nil
    var mimeType: String? = nil
    var value: () throws -> Data {
        get {
            return {
                guard let data = self.rawValue.data(using: String.Encoding.utf8) else {
                    throw HTTPIDLParameterEncodeError.EncodeToStringFailed
                }
                return data
            }
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
    var fileName: String? = nil
    var mimeType: String? = nil
    var value: () throws -> Data {
        get {
            return {
                guard let data = String(self.rawValue).data(using: String.Encoding.utf8) else {
                    throw HTTPIDLParameterEncodeError.EncodeToStringFailed
                }
                return data
            }
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
    var fileName: String? = nil
    var mimeType: String? = nil
    var value: () throws -> Data {
        get {
            return {
                let data = try Data(contentsOf: self.url, options: Data.ReadingOptions.mappedIfSafe)
                return data
            }
        }
    }
    
    init(with key: String, url: URL, fileName: String?, mimeType: String?) {
        self.key = key
        self.url = url
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

struct DataParameter: HTTPIDLParameter {
    var key: String
    var data: Data
    var fileName: String? = nil
    var mimeType: String? = nil
    var value: () throws -> Data {
        get {
            return {
                return self.data
            }
        }
    }
    
    init(with key: String, data: Data, fileName: String?, mimeType: String?) {
        self.key = key
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

