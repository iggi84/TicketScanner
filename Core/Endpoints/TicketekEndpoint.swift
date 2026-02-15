//
//  TicketekEndpoint.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

enum TicketekEndpoint: APIEndpoint {
    
    case getVenues(latitude: Double, longitude: Double)
    case scanTicket(venueCode: String, barcode: String)
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .getVenues:
            return "/venues/"
        case .scanTicket(let venueCode, _):
            return "/venues/\(venueCode)/pax/entry/scan"
        }
    }
    
    // MARK: - HTTP Method
    
    var method: HTTPMethod {
        switch self {
        case .getVenues:
            return .get
        case .scanTicket:
            return .post
        }
    }
    
    // MARK: - Parameters
    
    var parameters: Parameters? {
        switch self {
        case .getVenues(let latitude, let longitude):
            return [
                "latitude": latitude,
                "longitude": longitude
            ]
        case .scanTicket:
            return nil
        }
    }
    
    // MARK: - Body
    
    var body: Encodable? {
        switch self {
        case .getVenues:
            return nil
        case .scanTicket(_, let barcode):
            return ScanRequestBody(barcode: barcode)
        }
    }
    
    // MARK: - Encoding
    
    var encoding: ParameterEncoding {
        switch self {
        case .getVenues:
            return .url
        case .scanTicket:
            return .json
        }
    }
}

// MARK: - Request Body

struct ScanRequestBody: Encodable, Sendable {
    let barcode: String
}
