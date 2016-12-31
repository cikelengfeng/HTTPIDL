//
//  HTTPIDLRequestEncoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct HTTPBaseRequestEncoder: HTTPRequestEncoder {
    func encode(_ request: HTTPIDLRequest) throws -> HTTPRequest {
        return HTTPBaseRequest(with: "get", url: URL(fileURLWithPath: ""), headers: [:], body: { () -> Data in
            return Data()
        })
    }
}
