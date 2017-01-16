//
//  ResponseContent.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/7.
//
//

import Foundation

public enum ResponseContent {
    case int64(value: Int64)
    case int32(value: Int32)
    case bool(value: Bool)
    case double(value: Double)
    case string(value: String)
    case data(value: Data, fileName: String?, mimeType: String)
    case array(value: [ResponseContent])
    case dictionary(value: [String: ResponseContent])
}

public protocol ResponseContentConvertible {
    init?(content: ResponseContent?)
}

extension Int64: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .bool(let value):
            self.init(value ? 1 : 0)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .double:
            return nil
        }
    }
}

extension Int32: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .bool(let value):
            self.init(value ? 1 : 0)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .double:
            return nil
        }
    }
}

extension Bool: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .bool(let value):
            self.init(value)
        case .array, .dictionary, .data, .double, .int64, .int32, .string:
            return nil
        }
    }
}

extension Double: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .bool(let value):
            self.init(value ? 1 : 0)
        case .double(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data:
            return nil
        }
    }
}

extension String: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .int64(let value):
            self.init(value)
        case .int32(let value):
            self.init(value)
        case .bool(let value):
            self.init(value ? "1" : "0")
        case .string(let value):
            self.init(value)
        case .data(let value, _, _):
            self.init(data: value, encoding: String.Encoding.utf8)
        case .array, .dictionary, .double:
            return nil
        }
    }
}

public extension Array where Element: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .array(let value):
            self.init(value.flatMap({
                return Element(content: $0)
            }))
        case .dictionary, .data, .double, .int32, .int64, .string, .bool:
            return nil
        }
    }
}

public protocol ResponseContentKeyType: Hashable {
    init(string: String)
}

extension String: ResponseContentKeyType {
    public init(string: String) {
        self = string
    }
}

public extension Dictionary where Key: ResponseContentKeyType, Value: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .dictionary(let value):
            self = value.reduce([Key: Value](), { (soFar, soGood) in
                guard let v = Value(content: soGood.value) else {
                    return soFar
                }
                var ret = soFar
                ret[Key(string: soGood.key)] = v
                return ret
            })
            case .array, .data, .double, .int32, .int64, .string, .bool:
            return nil
        }
    }
}
