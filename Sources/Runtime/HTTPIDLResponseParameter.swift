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
    init?(parameter: HTTPIDLResponseParameter)
}

extension Int64: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter) {
        switch parameter {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        default:
            return nil
        }
    }
}

extension Int32: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter) {
        switch parameter {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        default:
            return nil
        }
    }
}

extension Double: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter) {
        switch parameter {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .double(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        default:
            return nil
        }
    }
}

extension String: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter) {
        switch parameter {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .data(let value, _, _):
            self.init(data: value, encoding: String.Encoding.utf8)
        default:
            return nil
        }
    }
}

extension HTTPData: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter) {
        switch parameter {
        case .data(let value, let fileName, let mimeType):
            self.init(with: value, fileName: fileName ?? "", mimeType: mimeType)
        default:
            return nil
        }
    }
}

extension HTTPFile: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter) {
        //暂不支持，后续打算把参数内容写进临时文件，然后用临时文件地址初始化
            return nil
    }
}

public extension Array where Element: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter) {
        switch parameter {
        case .array(let value):
            self.init(value.flatMap({
                return Element(parameter: $0)
            }))
        default:
            return nil
        }
    }
}

public protocol HTTPIDLResponseParameterKey {
    func asString() -> String
}

extension String: HTTPIDLResponseParameterKey {
    public func asString() -> String {
        return self
    }
}

public extension Dictionary where Key: HTTPIDLResponseParameterKey & Hashable, Value: HTTPIDLResponseParameterConvertible {
    public init?(parameter: HTTPIDLResponseParameter) {
        switch parameter {
        case .dictionary(let value):
            self = value.reduce([String: Value](), { (soFar, soGood) in
                guard let v = Value(parameter: soGood.value) else {
                    return soFar
                }
                var ret = soFar
                ret[soGood.key] = v
                return ret
            })
        default:
            return nil
        }
    }
}
