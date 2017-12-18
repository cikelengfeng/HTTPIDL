//
//  CompoundInputStream.swift
//  Pods
//
//  Created by 徐 东 on 2017/7/22.
//
//

import Foundation

class CompoundInputStream: InputStream {
    
    private var subStream: [InputStream] = []
    private var currentIndex: Int = 0
    private var _delegate: StreamDelegate?
    private var _streamError: Error?
    private var _streamStatus: Stream.Status = Stream.Status.notOpen
    
    class func create(withSubStream subStream: [InputStream]) -> CompoundInputStream {
        let stream = CompoundInputStream()
        stream.subStream = subStream
        return stream
    }
    
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        guard self.currentIndex < self.subStream.count else {
            return 0
        }
        _streamStatus = .reading
        let current = self.subStream[self.currentIndex]
        let count = current.read(buffer, maxLength: len)
        if !current.hasBytesAvailable {
            self.currentIndex += 1
            if self.currentIndex == self.subStream.count {
                _streamStatus = .atEnd
                self.delegate?.stream?(self, handle: Stream.Event.endEncountered)
            }
        }
        return count
    }
    
    override func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return false
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
    
    override func open() {
        _streamStatus = Stream.Status.opening
        self.subStream.forEach { (s) in
            s.open()
        }
        _streamStatus = Stream.Status.open
        self.delegate?.stream?(self, handle: Stream.Event.openCompleted)
    }
    
    override func close() {
        self.subStream.forEach { (s) in
            s.close()
        }
        _streamStatus = Stream.Status.closed
    }
    
    override var delegate: StreamDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    override var streamStatus: Stream.Status {
        return _streamStatus
    }
    
    override var streamError: Error? {
        return _streamError
    }
    
    override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        self.subStream.forEach { (s) in
            s.schedule(in: aRunLoop, forMode: mode)
        }
    }
    
    override func remove(from aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        self.subStream.forEach { (s) in
            s.remove(from: aRunLoop, forMode: mode)
        }
    }
    
    override func property(forKey key: Stream.PropertyKey) -> Any? {
        guard self.currentIndex < self.subStream.count else {
            return nil
        }
        let current = self.subStream[self.currentIndex]
        return current.property(forKey: key)
    }
    
    override func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        guard self.currentIndex < self.subStream.count else {
            return false
        }
        let current = self.subStream[self.currentIndex]
        return current.setProperty(property, forKey: key)
    }
}
