//
//  URLEncodeHelper.swift
//  HTTPIDL
//
//  Created by 徐 东 on 2017/12/21.
//

import Foundation

extension CharacterSet {
    static let httpURLEncodedFormAllowed: CharacterSet = {
        var set = CharacterSet.urlQueryAllowed
        set.remove(charactersIn: "+")
        return set
    }()
}

extension String {
    func urlEncodedForHTTPForm() -> String? {
        guard let step1 = self.addingPercentEncoding(withAllowedCharacters: .httpURLEncodedFormAllowed) else {
            return nil
        }
        //whitespace is %20 now, we replace it with '+', ref:https://www.w3.org/TR/html401/interact/forms.html#h-17.13.4.1
        let step2 = step1.replacingOccurrences(of: "%20", with: "+")
        return step2
    }
}
