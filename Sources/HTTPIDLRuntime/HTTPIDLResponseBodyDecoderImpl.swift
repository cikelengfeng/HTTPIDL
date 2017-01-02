//
//  HTTPIDLResponseBodyDecoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

struct HTTPResponseBodyJSONDecoder: HTTPResponseBodyDecoder {
    
    static let shared = HTTPResponseBodyJSONDecoder()
    
    typealias OutputType = Any
    
    func decode(_ responseBody: Data) throws -> Any {
        return try JSONSerialization.jsonObject(with: responseBody, options: .allowFragments)
    }
}
