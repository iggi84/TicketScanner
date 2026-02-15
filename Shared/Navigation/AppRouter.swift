//
//  AppRouter.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import SwiftUI

@Observable
final class AppRouter {
    
    // MARK: - Properties
    
    var currentFlow: AppFlow = .splash
    
    // MARK: - Navigation Methods
    
    func showLocationPermission() {
        currentFlow = .locationPermission
    }
    
    func showVenueSelection() {
        currentFlow = .venueSelection
    }
    
    func showScanner(for venue: Venue) {
        currentFlow = .scanner(venue: venue)
    }
    
    func backToVenueSelection() {
        currentFlow = .venueSelection
    }
}
