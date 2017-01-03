//
//  Multipart.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/5.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

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
