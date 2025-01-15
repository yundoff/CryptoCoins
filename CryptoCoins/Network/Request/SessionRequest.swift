//
//  SessionRequest.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

struct SessionRequest {
    
    let method: HTTPMethod
    let scheme: String
    let host: String
    let path: String
    
    private(set) var query: [URLQueryItem] = []
    private(set) var headers: [String: String] = [:]
    
    var urlRequest: URLRequest? {
        guard let url = urlComponents.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        headers.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        
        components.scheme = scheme
        components.percentEncodedHost = host
        components.path = path
        components.queryItems = query
        
        return components
    }
}

// MARK: - SessionRequest+HTTPMethod

extension SessionRequest {
    
    enum HTTPMethod: String {
        
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
}

// MARK: - Helpers

extension SessionRequest {
    
    static func baseRequest(method: HTTPMethod = .get, path: String) -> Self {
        .init(
            method: method,
            scheme: "https",
            host: "api.coincap.io",
            path: path
        )
    }
    
    // MARK: - Headers
    
    @discardableResult
    func headers(_ value: [String: String]) -> Self {
        var new = self
        
        new.headers = headers.merging(value) { $1 }
        
        return new
    }
    
    // MARK: - Query
    
    @discardableResult
    func query(_ value: [String: String]) -> Self {
        var new = self
        
        new.query = query
        
        return new
    }
}
