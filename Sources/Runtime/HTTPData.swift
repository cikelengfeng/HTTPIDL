//
//  Data.swift
//  Pods
//
//  Created by 徐 东 on 2017/8/17.
//
//

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
