//
//  ApiEndpoint.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

// MARK: - HTTP Method

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - Parameter Encoding

public enum ParameterEncoding: Sendable {
    case json
    case url
}

// MARK: - Type Aliases

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

// MARK: - API Endpoint Protocol

public protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var body: Encodable? { get }
    var encoding: ParameterEncoding { get }
}

// MARK: - Default Implementations

public extension APIEndpoint {
    
    var headers: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "accept-language": "en"
        ]
    }
    
    var parameters: Parameters? { nil }
    var body: Encodable? { nil }
    var encoding: ParameterEncoding { .json }
}
