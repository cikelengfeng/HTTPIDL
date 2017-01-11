//
//  URLHelper.swift
//  HTTPIDLDemo
//
//  Created by 徐 东 on 2017/1/11.
//  Copyright © 2017年 dx lab. All rights reserved.
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

fileprivate func valid(_ key: String) -> (URLQueryItem) -> Bool {
    return { item -> Bool in item.name == key && item.value != nil }
}

fileprivate func queryValueIsInt64() -> (URLQueryItem) -> Bool {
    return { item -> Bool in
        guard let value = item.value else {
            return false
        }
        return Int64(value) != nil
    }
}

fileprivate func &&<T> (lhs: @escaping (T) -> Bool, rhs: @escaping (T) -> Bool) -> (T) -> Bool {
    return { lhs($0) && rhs($0) }
}

fileprivate func ||<T> (lhs: @escaping (T) -> Bool, rhs: @escaping (T) -> Bool) -> (T) -> Bool {
    return { lhs($0) || rhs($0) }
}

extension URL {
    func obtainQuery() -> [URLQueryItem] {
        guard let components = NSURLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return []
        }
        return components.queryItems ?? []
    }
    
    func obtainQuery(for key: String) -> [String] {
        return obtainQuery().filter(valid(key)) .map { $0.value ?? "" }
    }
    
    func obtainInt64Query(for key: String) -> [Int64] {
        return obtainQuery().filter(valid(key) && queryValueIsInt64()) .map {
            guard let value = $0.value else {
                return 0
            }
            return Int64(value) ?? 0
        }
    }
    
    func obtainFirstQuery(for key: String) -> String? {
        guard let queryItem = obtainQuery().first(where: valid(key)) else {
            return nil
        }
        return queryItem.value
    }
    
    func obtainFirstInt64Query(for key: String) -> Int64? {
        guard
            let queryItem = obtainQuery().first(where: valid(key) && queryValueIsInt64()),
            let value = queryItem.value
            else {
                return nil
        }
        return Int64(value)
    }
}
