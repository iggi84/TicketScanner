//
//  ScanResponse.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

struct ScanResponse: Decodable, Sendable {
    let status: String?
    let action: String?
    let result: String?
    let concession: Int?
    
    var isSuccess: Bool {
        result?.uppercased() == "SUCCESS"
    }
     
    var displayMessage: String {
        if isSuccess {
            return status ?? "Valid Ticket"
        }
        return status ?? result ?? "Ticket validation failed"
    }
}
