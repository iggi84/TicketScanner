//
//  Gate.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

struct Gate: Decodable, Sendable, Identifiable {
    let name: String?
    
    var id: String { name ?? UUID().uuidString }
}
