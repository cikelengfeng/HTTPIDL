//
//  ResponseParameter.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/7.
//
//

import Foundation

public enum ResponseParameter {
    case int64(value: Int64)
    case int32(value: Int32)
    case double(value: Double)
    case string(value: String)
    case data(value: Data, fileName: String?, mimeType: String)
    case array(value: [ResponseParameter])
    case dictionary(value: [String: ResponseParameter])
}

public protocol ResponseParameterConvertible {
    init?(parameter: ResponseParameter?)
}

extension Int64: ResponseParameterConvertible {
    public init?(parameter: ResponseParameter?) {
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

extension Int32: ResponseParameterConvertible {
    public init?(parameter: ResponseParameter?) {
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

extension Double: ResponseParameterConvertible {
    public init?(parameter: ResponseParameter?) {
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

extension String: ResponseParameterConvertible {
    public init?(parameter: ResponseParameter?) {
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

public extension Array where Element: ResponseParameterConvertible {
    public init?(parameter: ResponseParameter?) {
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

public protocol ResponseParameterKeyType: Hashable {
    init(string: String)
}

extension String: ResponseParameterKeyType {
    public init(string: String) {
        self = string
    }
}

public extension Dictionary where Key: ResponseParameterKeyType, Value: ResponseParameterConvertible {
    public init?(parameter: ResponseParameter?) {
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
