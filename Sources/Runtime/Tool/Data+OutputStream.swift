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
        var buffer = [UInt8](repeating: 0, count: self.count)
        self.copyBytes(to: &buffer, count: self.count)
        
        return try write(&buffer, to: stream)
    }
    
    private func write(_ buffer: inout [UInt8], to outputStream: OutputStream) throws {
        var bytesToWrite = buffer.count
        
        while bytesToWrite > 0, outputStream.hasSpaceAvailable {
            let bytesWritten = outputStream.write(buffer, maxLength: bytesToWrite)
            
            if let error = outputStream.streamError {
                throw error
            }
            
            bytesToWrite -= bytesWritten
            
            if bytesToWrite > 0 {
                buffer = Array(buffer[bytesWritten..<buffer.count])
            }
        }
    }
}

