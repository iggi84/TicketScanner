//
//  ContentView.swift
//  TEG Ticket App
//
//  Created by Igor Vojinovic on 15/02/2026.
//

import SwiftUI

struct RootView: View {
    
    @State private var router = AppRouter()
    @State private var locationService = LocationService()
    
    var body: some View {
        Group {
            switch router.currentFlow {
            case .splash:
                SplashView {
                    handleSplashComplete()
                }
                
            case .locationPermission:
                LocationPermissionView(locationService: locationService) {
                    router.showVenueSelection()
                }
                
            case .venueSelection:
                VenueListView(locationService: locationService) { venue in
                    router.showScanner(for: venue)
                }
                
            case .scanner(let venue):
                ScannerView(venue: venue) {
                    router.backToVenueSelection()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: router.currentFlow)
    }
    
    // MARK: - Navigation Logic
    
    private func handleSplashComplete() {
        if locationService.isAuthorized {
            locationService.requestLocation()
            router.showVenueSelection()
        } else {
            router.showLocationPermission()
        }
    }
}

#Preview {
    RootView()
}
