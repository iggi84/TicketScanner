//
//  Venue.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

struct Venue: Decodable, Sendable, Identifiable {
    let code: String?
    let name: String?
    let address: String?
    let city: String?
    let state: String?
    let postcode: String?
    let latitude: Double?
    let longitude: Double?
    let timezone: String?
    let paxLocations: [PaxLocation]?
    
    var id: String { code ?? UUID().uuidString }
    
    var formattedLocation: String {
        [city, state, postcode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
    
    private enum CodingKeys: String, CodingKey {
        case code, name, address, city, state, postcode
        case latitude, longitude, timezone
        case paxLocations = "pax_locations"
    }
}
