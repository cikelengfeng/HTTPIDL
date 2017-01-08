//
//  HTTPIDLResponseParameter.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/7.
//
//

import Foundation

public enum HTTPIDLResponseParameter {
    case int64(value: Int64)
    case int32(value: Int32)
    case double(value: Double)
    case string(value: String)
    case data(value: Data, fileName: String?, mimeType: String)
    case array(value: [HTTPIDLResponseParameter])
    case dictionary(value: [String: HTTPIDLResponseParameter])
}

public protocol HTTPIDLResponseParameterConvertible {
    init?(parameter: HTTPIDLResponseParameter?)
}

extension Int64: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter?) {
        guard let parameter = parameter else {
            return nil
        }
        switch parameter {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .double:
            return nil
        }
    }
}

extension Int32: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter?) {
        guard let parameter = parameter else {
            return nil
        }
        switch parameter {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .double:
            return nil
        }
    }
}

extension Double: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter?) {
        guard let parameter = parameter else {
            return nil
        }
        switch parameter {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .double(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data:
            return nil
        }
    }
}

extension String: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter?) {
        guard let parameter = parameter else {
            return nil
        }
        switch parameter {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .data(let value, _, _):
            self.init(data: value, encoding: String.Encoding.utf8)
        case .array, .dictionary, .double:
            return nil
        }
    }
}

extension HTTPData: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter?) {
        guard let parameter = parameter else {
            return nil
        }
        switch parameter {
        case .data(let value, let fileName, let mimeType):
            self.init(with: value, fileName: fileName ?? "", mimeType: mimeType)
        case .array, .dictionary, .double, .int32, .int64, .string:
            return nil
        }
    }
}

extension HTTPFile: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter?) {
        //暂不支持，后续打算把参数内容写进临时文件，然后用临时文件地址初始化
            return nil
    }
}

public extension Array where Element: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter?) {
        guard let parameter = parameter else {
            return nil
        }
        switch parameter {
        case .array(let value):
            self.init(value.flatMap({
                return Element(parameter: $0)
            }))
        case .dictionary, .data, .double, .int32, .int64, .string:
            return nil
        }
    }
}

public protocol HTTPIDLResponseParameterKeyType: Hashable {
    init(string: String)
}

extension String: HTTPIDLResponseParameterKeyType {
    public init(string: String) {
        self = string
    }
}

public extension Dictionary where Key: HTTPIDLResponseParameterKeyType, Value: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter?) {
        guard let parameter = parameter else {
            return nil
        }
        switch parameter {
        case .dictionary(let value):
            self = value.reduce([Key: Value](), { (soFar, soGood) in
                guard let v = Value(parameter: soGood.value) else {
                    return soFar
                }
                var ret = soFar
                ret[Key(string: soGood.key)] = v
                return ret
            })
            case .array, .data, .double, .int32, .int64, .string:
            return nil
        }
    }
}
