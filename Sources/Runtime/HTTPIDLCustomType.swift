//
//  Multipart.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/5//

import Foundation

public struct HTTPData {
    public let payload: Data
    public let fileName: String
    public let mimeType: String
    
    public init(with payload: Data, fileName: String, mimeType: String) {
        self.payload = payload
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

extension HTTPData: RequestContentConvertible {
    public func asRequestContent() -> RequestContent {
        return .data(value: payload, fileName: fileName, mimeType: mimeType)
    }
}

extension HTTPData: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        guard let content = content else {
            return nil
        }
        switch content {
        case .data(let value, let fileName, let mimeType):
            self.init(with: value, fileName: fileName ?? "", mimeType: mimeType)
        case .file(let url, let fileName, let mimeType):
            guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else {
                return nil
            }
            self.init(with: data, fileName: fileName ?? "", mimeType: mimeType)
        case .array, .dictionary, .string, .number:
            return nil
        }
    }
}

public struct HTTPFile {
    public let payload: URL
    public let fileName: String
    public let mimeType: String
    
    public init(with payload: URL, fileName: String, mimeType: String) {
        self.payload = payload
        self.fileName = fileName
        self.mimeType = mimeType
    }
}


extension HTTPFile: RequestContentConvertible {
    public func asRequestContent() -> RequestContent {
            return .file(value: payload, fileName: fileName, mimeType: mimeType)
    }
}



extension HTTPFile: ResponseContentConvertible {
    public init?(content: ResponseContent?) {
        //暂不支持，后续打算把参数内容写进临时文件，然后用临时文件地址初始化
        guard let content = content else {
            return nil
        }
        switch content {
        case .file(let url, let fileName, let mimeType):
            self.init(with: url, fileName: fileName ?? "", mimeType: mimeType)
        case .array, .dictionary, .string, .number, .data:
            return nil
        }
    }
}
