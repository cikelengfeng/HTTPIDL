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
    
    internal weak var futureImpl: HTTPRequestFuture?
    public let request: Request
    public var progressHandler: ((_ progress: Progress) -> Void)?
    public var responseHandler: ((_ response: Response) -> Void)? = nil
    public var errorHandler: ((_ error: HIError) -> Void)?
    
    internal func notify(progress: Progress) {
        guard let handler = self.progressHandler else {
            return
        }
        request.configuration.callbackQueue.async {
            handler(progress)
        }
    }
    
    internal func notify(response: Response) {
        guard let handler = self.responseHandler else {
            return
        }
        request.configuration.callbackQueue.async {
            handler(response)
        }
    }
    
    internal func notify(error: HIError) {
        guard let handler = self.errorHandler else {
            return
        }
        request.configuration.callbackQueue.async {
            handler(error)
        }
    }
    
    init(request: Request) {
        self.request = request
    }
}
