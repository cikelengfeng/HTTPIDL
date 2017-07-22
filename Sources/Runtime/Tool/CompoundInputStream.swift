//
//  CompoundInputStream.swift
//  Pods
//
//  Created by 徐 东 on 2017/7/22.
//
//

import Foundation

class CompoundInputStream: InputStream {
    
    private let subStream: [InputStream]
    private var currentIndex: Int
    
    init(subStream: [InputStream]) {
        self.subStream = subStream
        self.currentIndex = 0
        super.init(data: Data())
    }
    
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        guard self.currentIndex < self.subStream.count else {
            return 0
        }
        let current = self.subStream[self.currentIndex]
        let count = current.read(buffer, maxLength: len)
        if !current.hasBytesAvailable {
            self.currentIndex += 1
        }
        return count
    }
    
    override var hasBytesAvailable: Bool {
        get {
            guard self.currentIndex < self.subStream.count else {
                return false
            }
            let current = self.subStream[self.currentIndex]
            return current.hasBytesAvailable
        }
    }
}
