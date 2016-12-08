//
//  Multipart.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/5.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct MultipartFile {
    let payload: URL
    let fileName: String
    let mimeType: String
    
    init(with payload: URL, fileName: String, mimeType: String) {
        self.payload = payload
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

struct MultipartData {
    let payload: Data
    let fileName: String
    let mimeType: String
    
    init(with payload: Data, fileName: String, mimeType: String) {
        self.payload = payload
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
