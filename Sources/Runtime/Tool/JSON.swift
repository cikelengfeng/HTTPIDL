//
//  JSON.swift
//  Pods
//
//  Created by 徐 东 on 2017/2/10.
//
//

import Foundation

public enum HTTPJSONEncoderError: HIError {
    case fileIsForbidden(file: URL)
    case dataIsForbidden(data: Data)
    case illegalRootRequestContent(parameter: RequestContent)
    case illegalRootResponseContent(parameter: ResponseContent)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .fileIsForbidden(_):
                return "json request encoder 不支持文件参数, \(self)"
            case .dataIsForbidden(_):
                return "json request encoder 不支持Data参数, \(self)"
            case .illegalRootRequestContent(let parameter):
                return "json request encoder 只支持数组和字典类型做根参数, 错误参数: \(parameter)"
            case .illegalRootResponseContent(let parameter):
                return "json request encoder 只支持数组和字典类型做根参数, 错误参数: \(parameter)"
            }
        }
    }
}

public extension RequestContent {
    
    public func jsonObject() throws -> Any {
        switch self {
        case .int64, .int32, .bool, .double, .string:
            throw HTTPJSONEncoderError.illegalRootRequestContent(parameter: self)
        case .file(let url, _, _):
            throw HTTPJSONEncoderError.fileIsForbidden(file: url)
        case .data(let data, _, _):
            throw HTTPJSONEncoderError.dataIsForbidden(data: data)
        case .array, .dictionary:
            return try self.jsonLeaf()
        }
    }
    
    private func jsonLeaf() throws -> Any {
        switch self {
        case .int64(let value):
            return value
        case .int32(let value):
            return value
        case .bool(let value):
            return value
        case .double(let value):
            return value
        case .string(let value):
            return value
        case .file(let url, _, _):
            throw HTTPJSONEncoderError.fileIsForbidden(file: url)
        case .data(let data, _, _):
            throw HTTPJSONEncoderError.dataIsForbidden(data: data)
        case .array(let array):
            return try array.map({ (paramInArray) in
                return try paramInArray.jsonLeaf()
            })
        case .dictionary(let dict):
            return try dict.reduce([:], { (soFar, soGood) in
                var result = soFar
                result[soGood.key] = try soGood.value.jsonLeaf()
                return result
            })
        }
    }
}

public extension ResponseContent {
    
    public func jsonObject() throws -> Any {
        switch self {
        case .int64, .int32, .bool, .double, .string:
            throw HTTPJSONEncoderError.illegalRootResponseContent(parameter: self)
        case .data(let data, _, _):
            throw HTTPJSONEncoderError.dataIsForbidden(data: data)
        case .array, .dictionary:
            return try self.jsonLeaf()
        }
    }

    private func jsonLeaf() throws -> Any {
        switch self {
        case .int64(let value):
            return value
        case .int32(let value):
            return value
        case .bool(let value):
            return value
        case .double(let value):
            return value
        case .string(let value):
            return value
        case .data(let data, _, _):
            throw HTTPJSONEncoderError.dataIsForbidden(data: data)
        case .array(let array):
            return try array.map({ (paramInArray) in
                return try paramInArray.jsonLeaf()
            })
        case .dictionary(let dict):
            return try dict.reduce([:], { (soFar, soGood) in
                var result = soFar
                result[soGood.key] = try soGood.value.jsonLeaf()
                return result
            })
        }
    }
    
}
