//
//  VenuesResponse.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

struct VenuesResponse: Decodable, Sendable {
    let venues: [Venue]?
}
