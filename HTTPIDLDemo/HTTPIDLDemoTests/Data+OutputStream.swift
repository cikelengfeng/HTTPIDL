//
//  Data+OutputStream.swift
//  Pods
//
//  Created by 徐 东 on 2017/7/23.
//
//

import Foundation

extension Data {
    func writeTo(stream: OutputStream) throws {
        try self.withUnsafeBytes { (buffer) in
            try write(buffer: buffer, count: self.count, to: stream)
        }
    }
    
    private func write(buffer: UnsafePointer<UInt8>, count: Int, to outputStream: OutputStream) throws {
        var bytesToWrite = count
        while bytesToWrite > 0, outputStream.hasSpaceAvailable {
            let bytesWritten = outputStream.write(buffer, maxLength: bytesToWrite)
            
            if let error = outputStream.streamError {
                throw error
            }
            
            bytesToWrite -= bytesWritten
        }
    }
}

