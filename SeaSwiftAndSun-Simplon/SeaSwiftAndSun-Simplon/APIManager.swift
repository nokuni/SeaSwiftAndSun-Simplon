//
//  APIManager.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Yann Christophe Maertens on 11/12/2023.
//

import Foundation
import SwiftUI

public final class APIManager {
    
    public init() { }
    
    /// All HTTP methods to initiate a request.
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    private enum APIError: String {
        case url = "The URL for the request is wrong"
        case response = "Server ERROR"
        case data = "No DATA"
        case decoding = "Something went wrong on decoding the data"
        case encoding = "Something went wrong on encoding the data"
    }
    
    private func getURL(_ url: String) throws -> URL {
        guard let url = URL(string: url) else { throw APIError.url.rawValue }
        return url
    }
    
    private func urlRequest(url: URL,
                            httpMethod: HTTPMethod,
                            cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy)
        request.httpMethod = httpMethod.rawValue
        if httpMethod == .post || httpMethod == .put {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        return request
    }
    
    private func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
    
    private func getDecoder(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                            dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                            keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        return decoder
    }
    
    private func sharedData(request: URLRequest) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(for: request)
    }
    
    private func encodedObject<T: Codable>(value: T) throws -> Data {
        do {
            let object = try encode(value)
            return try JSONSerialization.data(withJSONObject: object)
        } catch {
            throw APIError.encoding.rawValue
        }
    }
    
    private func requestedData(request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        do {
            return try await sharedData(request: request)
        } catch {
            throw APIError.response.rawValue
        }
    }
    
    private func decodedData<T: Codable>(request: URLRequest,
                                         decoder: JSONDecoder) async throws -> T {
        do {
            let data = try await requestedData(request: request).data
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding.rawValue
        }
    }
    
    private func cleanURL(_ url: String) -> String {
        let hasLastSlash: Bool = url.isLastCharacter("/")
        let slash: String = hasLastSlash ? "/" : ""
        return hasLastSlash ? url : "\(url)\(slash)"
    }
    
    /// Returns the data from the HTTP request.
    private func request<T: Codable>(url: String,
                                     value: T? = nil,
                                     httpMethod: HTTPMethod,
                                     key: String? = nil,
                                     htttpHeaderField: String? = nil,
                                     cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                                     dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                     dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                     keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        let url: URL = try getURL(url)
        
        var request = urlRequest(url: url,
                                 httpMethod: httpMethod,
                                 cachePolicy: cachePolicy)
        
        if let key, let htttpHeaderField {
            request.addValue(key, forHTTPHeaderField: htttpHeaderField)
        }
        
        if httpMethod == .post || httpMethod == .put {
            request.httpBody = try encodedObject(value: value)
        }
        
        let decoder = getDecoder(dateDecodingStrategy: dateDecodingStrategy,
                                 dataDecodingStrategy: dataDecodingStrategy,
                                 keyDecodingStrategy: keyDecodingStrategy)
        
        return try await decodedData(request: request, decoder: decoder)
    }
    
    /// Simple formatted method to GET data.
    public func get<T: Codable>(url: String,
                                key: String? = nil,
                                htttpHeaderField: String? = nil,
                                cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                                dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        try await request(url: url,
                          httpMethod: .get,
                          key: key,
                          htttpHeaderField: htttpHeaderField,
                          cachePolicy: cachePolicy,
                          dateDecodingStrategy: dateDecodingStrategy,
                          dataDecodingStrategy: dataDecodingStrategy,
                          keyDecodingStrategy: keyDecodingStrategy)
    }
    
    /// Simple formatted method to GET data with an ID.
    public func get<T: Codable>(url: String,
                                id: Int,
                                key: String? = nil,
                                htttpHeaderField: String? = nil,
                                cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                                dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        try await request(url: "\(cleanURL(url))\(id)",
                          httpMethod: .get,
                          key: key,
                          htttpHeaderField: htttpHeaderField,
                          cachePolicy: cachePolicy,
                          dateDecodingStrategy: dateDecodingStrategy,
                          dataDecodingStrategy: dataDecodingStrategy,
                          keyDecodingStrategy: keyDecodingStrategy)
    }
    
    /// Simple formatted method to POST data.
    public func post<T: Codable>(url: String,
                                 value: T,
                                 cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                 dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                 keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        try await request(url: url,
                          httpMethod: .post,
                          cachePolicy: cachePolicy,
                          dateDecodingStrategy: dateDecodingStrategy,
                          dataDecodingStrategy: dataDecodingStrategy,
                          keyDecodingStrategy: keyDecodingStrategy)
    }
    
    /// Simple formatted method to PUT data.
    public func put<T: Codable>(url: String,
                                value: T,
                                cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                                dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        try await request(url: url,
                          httpMethod: .put,
                          cachePolicy: cachePolicy,
                          dateDecodingStrategy: dateDecodingStrategy,
                          dataDecodingStrategy: dataDecodingStrategy,
                          keyDecodingStrategy: keyDecodingStrategy)
    }
    
    /// Simple formatted method to PUT data with an ID.
    public func put<M: Codable>(url: String,
                                id: Int,
                                value: M,
                                cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                                dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> M {
        try await request(url: "\(cleanURL(url))\(id)",
                          httpMethod: .put,
                          cachePolicy: cachePolicy,
                          dateDecodingStrategy: dateDecodingStrategy,
                          dataDecodingStrategy: dataDecodingStrategy,
                          keyDecodingStrategy: keyDecodingStrategy)
    }
    
    /// Simple formatted method to DELETE data with an ID.
    public func delete<M: Codable>(url: String,
                                   id: Int,
                                   cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                                   dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                   dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                   keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> M {
        try await request(url: "\(cleanURL(url))\(id)",
                          httpMethod: .delete,
                          cachePolicy: cachePolicy,
                          dateDecodingStrategy: dateDecodingStrategy,
                          dataDecodingStrategy: dataDecodingStrategy,
                          keyDecodingStrategy: keyDecodingStrategy)
    }
}
