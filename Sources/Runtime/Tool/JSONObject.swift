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
    
    func jsonObject() throws -> Any {
        switch self {
        case .number, .string:
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
        case .number(let value):
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
    
    func jsonObject() throws -> Any {
        switch self {
        case .number, .string:
            throw HTTPJSONEncoderError.illegalRootResponseContent(parameter: self)
        case .data(let data, _, _):
            throw HTTPJSONEncoderError.dataIsForbidden(data: data)
        case .file(let url, _, _):
            throw HTTPJSONEncoderError.fileIsForbidden(file: url)
        case .array, .dictionary:
            return try self.jsonLeaf()
        }
    }

    private func jsonLeaf() throws -> Any {
        switch self {
        case .number(let value):
            return value
        case .string(let value):
            return value
        case .data(let data, _, _):
            throw HTTPJSONEncoderError.dataIsForbidden(data: data)
        case .file(let url, _, _):
            throw HTTPJSONEncoderError.fileIsForbidden(file: url)
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

public struct JSONObject: ResponseContentConvertible {
    
    public let json: Any
    
    public init?(content: ResponseContent?) {
        guard let c = content, let jsonobj = try? c.jsonObject() else {
            return nil
        }
        self.json = jsonobj
    }
    
    public init(json: Any) {
        self.json = json
    }
}

extension JSONObject: RequestContentConvertible {
    public func asRequestContent() -> RequestContent {
        if let dict = json as? [String: Any] {
            return requestContent(fromDict: dict)
        } else if let array = json as? [Any] {
            return requestContent(fromArray: array)
        } else if let simple = json as? RequestContentConvertible {
            return simple.asRequestContent()
        }
        return .dictionary(value: [:])
    }
    
    private func requestContent(fromDict dict: [String: Any]) -> RequestContent {
        var mapped: [String: RequestContent] = [:]
        dict.forEach { (kv) in
            let key = kv.key
            if let dict = kv.value as? [String: Any] {
                mapped[key] = requestContent(fromDict: dict)
            } else if let array = kv.value as? [Any] {
                mapped[key] = requestContent(fromArray: array)
            } else if let simple = kv.value as? RequestContentConvertible {
                mapped[key] = simple.asRequestContent()
            }
        }
        return .dictionary(value: mapped)
    }
    
    private func requestContent(fromArray array: [Any]) -> RequestContent {
        var mapped: [RequestContent] = []
        array.forEach { (element) in
            if let dict = element as? [String: Any] {
                mapped.append(requestContent(fromDict: dict))
            } else if let array = element as? [Any] {
                mapped.append(requestContent(fromArray: array))
            } else if let simple = element as? RequestContentConvertible {
                mapped.append(simple.asRequestContent())
            }
        }
        return .array(value: mapped)
    }
}
