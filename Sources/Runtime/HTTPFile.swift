//
//  Multipart.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/5//

import Foundation

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
