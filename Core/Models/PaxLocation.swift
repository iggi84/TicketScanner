//
//  PaxLocation.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

struct PaxLocation: Decodable, Sendable, Identifiable {
    let name: String?
    let gates: [Gate]?
    
    var id: String { name ?? UUID().uuidString }
}
