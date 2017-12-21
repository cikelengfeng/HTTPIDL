//
//  URLEncodeHelper.swift
//  HTTPIDL
//
//  Created by 徐 东 on 2017/12/21.
//

import Foundation

extension CharacterSet {
    static let httpURLQueryAllowed: CharacterSet = {
        var set = CharacterSet.urlQueryAllowed
        set.remove(charactersIn: "+")
        return set
    }()
}

extension String {
    func urlEncodedForHTTP() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .httpURLQueryAllowed)
    }
}
