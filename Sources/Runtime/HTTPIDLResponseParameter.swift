//
//  ResponseContent.swift
//  Pods
//
//  Created by 徐 东 on 2017/1/7//
//

import Foundation

public enum ResponseContent {
    case number(value: NSNumber)
    case string(value: String)
    case data(value: Data, fileName: String?, mimeType: String)
    case array(value: [ResponseContent])
    case dictionary(value: [String: ResponseContent])
    case file(value: URL, fileName: String?, mimeType: String)
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
        case .number(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .file:
            return nil
        }
    }
}

extension UInt64: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .number(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .file:
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
        case .number(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .file:
            return nil
        }
    }
}

extension UInt32: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .number(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .file:
            return nil
        }
    }
}

extension Int: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .number(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .file:
            return nil
        }
    }
}

extension UInt: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .number(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .file:
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
        case .number(let value):
            self.init(value)
        case .array, .dictionary, .data, .string, .file:
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
        case .number(let value):
            self.init(value)
        case .string(let value):
            self.init(value)
        case .array, .dictionary, .data, .file:
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
        case .number(let value):
            self.init(value.stringValue)
        case .string(let value):
            self.init(value)
        case .data(let value, _, _):
            self.init(data: value, encoding: String.Encoding.utf8)
        case .array, .dictionary, .file:
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
        case .dictionary, .data, .string, .number, .file:
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
        case .array, .data, .string, .number, .file:
            return nil
        }
    }
}
