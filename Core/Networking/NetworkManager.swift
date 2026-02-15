//
//  NetworkManager.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

// MARK: - Network Service Protocol

protocol NetworkService: Sendable {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

// MARK: - Network Manager

final class NetworkManager: NetworkService {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL: String
    private let decoder: JSONDecoder
    
    static let shared = NetworkManager()
    
    // MARK: - Configuration Constants
    
    private enum Config {
        static let timeoutInterval: TimeInterval = 30
    }
    
    // MARK: - Initialisation
    
    init(
        baseURL: String = Bundle.baseURL,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
        
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .useDefaultKeys
    }
    
    // MARK: - Public Methods
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let urlRequest = try buildRequest(for: endpoint)
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let urlError as URLError {
            throw mapURLError(urlError)
        } catch {
            throw NetworkError.unknown(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        try validateResponse(httpResponse, data: data)
        
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Helpers
    
    private func buildRequest(for endpoint: APIEndpoint) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        if endpoint.encoding == .url || endpoint.method == .get,
           let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = Config.timeoutInterval
        
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.setValue(Bundle.apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(Bundle.apiAuth, forHTTPHeaderField: "authorization")
        
        if endpoint.method != .get {
            if let body = endpoint.body {
                request.httpBody = try JSONEncoder().encode(body)
            } else if endpoint.encoding == .json, let parameters = endpoint.parameters {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
        }
        
        return request
    }
    
    // MARK: - Response Validation
    
    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 401:
            let message = extractErrorMessage(from: data) ?? "Unauthorised access."
            throw NetworkError.unauthorized(message: message)
        case 400...499:
            let message = extractErrorMessage(from: data) ?? "Request failed."
            throw NetworkError.requestFailed(statusCode: response.statusCode, message: message)
        case 503:
            throw NetworkError.serverOutage
        case 500...599:
            let message = extractErrorMessage(from: data) ?? "Server error. Please try again later."
            throw NetworkError.requestFailed(statusCode: response.statusCode, message: message)
        default:
            let message = extractErrorMessage(from: data) ?? "Unexpected error occurred."
            throw NetworkError.requestFailed(statusCode: response.statusCode, message: message)
        }
    }
    
    // MARK: - Error Handling
    
    private func extractErrorMessage(from data: Data) -> String? {
        
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            return json["message"] as? String
                ?? json["error"] as? String
                ?? json["status"] as? String
        }
        return String(data: data, encoding: .utf8)
    }
    
    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return .noInternet
        case .timedOut:
            return .requestFailed(statusCode: 0, message: "Request timed out. Please try again.")
        case .cannotFindHost, .cannotConnectToHost:
            return .requestFailed(statusCode: 0, message: "Cannot connect to the server.")
        default:
            return .unknown(error)
        }
    }
}
