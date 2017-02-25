//
//  RequestFuture.swift
//  Pods
//
//  Created by 徐 东 on 2017/2/25.
//
//

import Foundation

public class RequestFuture<Response> {
    
    public func cancel() {
        futureImpl?.cancel()
    }
    
    internal var futureImpl: HTTPRequestFuture?
    public let request: Request
    public var progressHandler: ((_ progress: Progress) -> Void)?
    public var responseHandler: ((_ response: Response) -> Void)? = nil
    public var errorHandler: ((_ error: HIError) -> Void)?
    
    internal func notify(progress: Progress) {
        request.configuration.callbackQueue.async {
            self.progressHandler?(progress)
        }
    }
    
    internal func notify(response: Response) {
        request.configuration.callbackQueue.async {
            self.responseHandler?(response)
        }
    }
    
    internal func notify(error: HIError) {
        request.configuration.callbackQueue.async {
            self.errorHandler?(error)
        }
    }
    
    init(request: Request) {
        self.request = request
    }
}
