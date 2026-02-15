//
//  NetworkError.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case noInternet
    case noData
    case decodingError(Error)
    case requestFailed(statusCode: Int, message: String?)
    case unauthorized(message: String)
    case serverOutage
    case unknown(Error)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noInternet:
            return "No internet connection. Please check your network settings."
        case .noData:
            return "No data received from the server."
        case .decodingError:
            return "Unable to process the server response."
        case .requestFailed(_, let message):
            return message ?? "An unexpected error occurred."
        case .unauthorized(let message):
            return message
        case .serverOutage:
            return "The service is temporarily unavailable. Please try again later."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}

extension NetworkError {
    
    var isRetryable: Bool {
        switch self {
        case .serverOutage, .noInternet:
            return true
        case .requestFailed(let statusCode, _):
            return statusCode >= 500
        default:
            return false
        }
    }
}
