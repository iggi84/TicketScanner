//
//  AppFlow.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

enum AppFlow: Equatable {
    case splash
    case locationPermission
    case venueSelection
    case scanner(venue: Venue)
    
    static func == (lhs: AppFlow, rhs: AppFlow) -> Bool {
        switch (lhs, rhs) {
        case (.splash, .splash),
             (.locationPermission, .locationPermission),
             (.venueSelection, .venueSelection):
            return true
        case (.scanner(let a), .scanner(let b)):
            return a.code == b.code
        default:
            return false
        }
    }
}
