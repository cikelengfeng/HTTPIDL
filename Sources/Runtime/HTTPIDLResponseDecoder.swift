//
//  ResponseBodyDecoderImpl.swift
//  everfilter
//
//  Created by 徐 东 on 2016/12/31.
//

import Foundation

private func decode(json: Any) throws -> ResponseContent? {
    if let number = json as? NSNumber {
        return .number(value: number)
    }else if let tmp = json as? String {
        return .string(value: tmp)
    } else if let tmp = json as? [Any] {
        return .array(value: try tmp.flatMap({
            return try decode(json: $0)
        }))
    } else if json is [String: Any], let tmp = json as? [String: Any] {
        return .dictionary(value: try tmp.reduce([String: ResponseContent](), { (soFar, soGood) in
            var ret = soFar
            ret[soGood.key] = try decode(json: soGood.value)
            return ret
        }))
    }
    return nil
}

private func decodeRoot(json: Any) throws -> ResponseContent? {
    if let tmp = json as? [String: Any] {
        return .dictionary(value: try tmp.reduce([String: ResponseContent](), { (soFar, soGood) in
            var ret = soFar
            ret[soGood.key] = try decode(json: soGood.value)
            return ret
        }))
    } else if let tmp = json as? [Any] {
        return .array(value: try tmp.flatMap({ (element) in
            return try decode(json: element)
        }))
    } else {
        return try decode(json: json)
    }
}

public enum HTTPResponseJSONDecoderError: HIError {
    case JSONSerializationError(rawError: Error)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .JSONSerializationError(let rawError):
                return (rawError as NSError).localizedDescription
            }
        }
    }
}

public struct HTTPResponseJSONDecoder: HTTPResponseDecoder {
    public var outputStream: OutputStream? {
        get {
            return OutputStream(toMemory: ())
        }
    }

    public var jsonReadOptions: JSONSerialization.ReadingOptions = .allowFragments
    
    public init() {
        
    }
    
    public func decode(_ response: HTTPResponse) throws -> ResponseContent? {
        guard let stream = response.bodyStream, let body = stream.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as? Data else {
            return nil
        }
        let json: Any
        do {
            json = try JSONSerialization.jsonObject(with: body, options: jsonReadOptions)
        } catch let error {
            throw HTTPResponseJSONDecoderError.JSONSerializationError(rawError: error)
        }
            
        return try decodeRoot(json: json)
    }
}

public struct HTTPResponseFileDecoder: HTTPResponseDecoder {
    public private(set) var outputStream: OutputStream?
    public private(set) var filePath: String;
    
    init(filePath: String) {
        self.filePath = filePath
        self.outputStream = OutputStream(toFileAtPath: filePath, append: false)
    }
    
    public func decode(_ response: HTTPResponse) throws -> ResponseContent? {
        let fileURL = URL(fileURLWithPath: self.filePath)
        let contentType = response.headers["Content-Type"] ?? "application/octet-stream"
        return ResponseContent.file(value: fileURL, fileName: nil, mimeType: contentType)
    }
}
