//
//  HTTPIDLResponseBodyDecoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//  Copyright © 2016年 Shanghai Infinite Memory. All rights reserved.
//

import Foundation

public struct HTTPResponseBodyJSONDecoder: HTTPResponseBodyDecoder {
    
    public static let shared = HTTPResponseBodyJSONDecoder()
    
    public typealias OutputType = Any
    
    public func decode(_ responseBody: Data) throws -> Any {
        return try JSONSerialization.jsonObject(with: responseBody, options: .allowFragments)
    }
}
