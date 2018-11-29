//
//  InputStream+Data.swift
//  Pods
//
//  Created by 徐 东 on 2017/7/22.
//
//

import Foundation

extension InputStream {
    func data() -> Data {
        var data = Data()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        self.open()
        while self.hasBytesAvailable {
            let count = self.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: count)
        }
        self.close()
        buffer.deallocate()
        return data
    }
}
