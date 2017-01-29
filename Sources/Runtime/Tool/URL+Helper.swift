//
//  URL+Helper.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/2.
//

import Foundation

extension URL {
    func appendQuery(pairs: [(String, String)]) -> URL {
        guard var components = URLComponents(string: absoluteString) else {
            return self
        }
        var queryItems = components.queryItems ?? []
        let appendedQueryItems = pairs.map { URLQueryItem(name: $0, value: $1) }
        queryItems.append(contentsOf: appendedQueryItems)
        components.queryItems = queryItems
        
        guard let newString = components.string, let newURL = URL(string: newString) else {
            return self
        }
        return newURL
    }
    
    func appendQuery(pairs: [(String, Int64)]) -> URL {
        return appendQuery(pairs: pairs.map { ($0, String($1)) })
    }
    
    func replaceOrAppendQuery(pairs: [(String, String)]) -> URL {
        guard var components = URLComponents(string: absoluteString) else {
            return self
        }
        
        var existQueryItemMap = components.queryItems?.reduce([String: [URLQueryItem]](), { (soFar, soGood) in
            let items = (soFar[soGood.name] ?? []) + [soGood]
            var new = soFar
            new[soGood.name] = items
            return new
        })
        
        let inputQueryItems = pairs.map { (name, value) -> URLQueryItem in
            _ = existQueryItemMap?.removeValue(forKey: name)
            return URLQueryItem(name: name, value: value)
        }
        
        let allItems = (existQueryItemMap?.reduce([URLQueryItem](), { $0 + $1.value }) ?? []) + inputQueryItems
        
        components.queryItems = allItems
        
        guard let newString = components.string, let newURL = URL(string: newString) else {
            return self
        }
        return newURL
    }
    
    func replaceOrAppendQuery(pairs: [(String, Int64)]) -> URL {
        return replaceOrAppendQuery(pairs: pairs.map { ($0, String($1)) })
    }
    
}
