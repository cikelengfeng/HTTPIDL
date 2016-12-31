//
//  HTTPIDLResponseImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/30.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct HTTPIDLBaseResponse: HTTPIDLResponse {
    var decoder: HTTPResponseBodyJSONDecoder = HTTPResponseBodyJSONDecoder()
    var value: Any?
    
    init(with httpResponse: HTTPResponse) throws {
        guard let httpBody = httpResponse.body else {
            value = nil;
            return
        }
        //这里要注意如果httpbody非空并且不能解析成json的话，我们要向外抛错，而不是把value置为nil，因为http协议中响应体在一些状态下可以为空（e.g. 1xx, 204)，所以我们要将解析出错与空值区分开
        value = try decoder.decode(httpBody)
    }
}
