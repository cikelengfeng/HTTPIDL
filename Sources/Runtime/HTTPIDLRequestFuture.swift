//
//  RequestFuture.swift
//  Pods
//
//  Created by 徐 东 on 2017/2/25.
//
//

import Foundation

public struct RequestFuture<Response> {
    
    public func cancel() {
        futureImpl.cancel()
    }
    
    public let request: Request
    private var futureImpl: HTTPRequestFuture
    public var progressHandler: ((_ progress: Progress) -> Void)? {
        get {
            return futureImpl.progressHandler
        }
        
        set(v) {
            futureImpl.progressHandler = v
        }
    }
    public var responseHandler: ((_ response: Response) -> Void)? = nil
    public var errorHandler: ((_ error: HIError) -> Void)? {
        get {
            return futureImpl.errorHandler
        }
        
        set(v) {
            futureImpl.errorHandler = v
        }
    }
}
