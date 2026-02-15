//
//  VenueListView.swift
//  TEG Ticket App
//
//  Created by Igor Vojinovic on 15/02/2026.
//

import SwiftUI
import CoreLocation

struct VenueListView: View {
    
    let locationService: LocationService
    let onVenueSelected: (Venue) -> Void
    
    @State private var viewModel = VenueListViewModel()
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            switch viewModel.viewState {
            case .idle, .loading:
                loadingView
                
            case .loaded:
                if viewModel.venues.isEmpty {
                    emptyView
                } else {
                    venueListView
                }
                
            case .error(let message):
                errorView(message: message)
            }
        }
        .task {
            await loadVenues()
        }
        .onChange(of: locationService.currentLocation?.latitude) { _, _ in
            Task { await loadVenues() }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: .spacingL) {
            ProgressView()
                .controlSize(.large)
                .tint(Color.appAccent)
            
            Text("Finding nearby venues...")
                .font(.headline)
                .foregroundStyle(Color.appTextSecondary)
        }
    }
    
    // MARK: - Empty View
    
    private var emptyView: some View {
        VStack(spacing: .spacingL) {
            Image(systemName: "building.2")
                .font(.system(size: .iconL))
                .foregroundStyle(Color.appTextSecondary)
            
            Text("No venues found nearby")
                .font(.headline)
                .foregroundStyle(Color.appTextPrimary)
            
            Text("Try moving closer to the venue or check your location settings.")
                .font(.body)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .spacingXL)
            
            Button("Retry") {
                Task { await loadVenues() }
            }
            .buttonStyle(AppButtonStyle())
        }
    }
    
    // MARK: - Venue List
    
    private var venueListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Select Venue")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.appTextPrimary)
                .padding(.horizontal, .spacingM)
                .padding(.top, .spacingL)
                .padding(.bottom, .spacingM)
            
            ScrollView {
                LazyVStack(spacing: .spacingS) {
                    ForEach(viewModel.venues) { venue in
                        VenueRow(venue: venue) {
                            onVenueSelected(venue)
                        }
                    }
                }
                .padding(.horizontal, .spacingM)
            }
        }
    }
    
    // MARK: - Error View
    
    private func errorView(message: String) -> some View {
        VStack(spacing: .spacingL) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: .iconL))
                .foregroundStyle(Color.appError)
            
            Text("Something went wrong")
                .font(.headline)
                .foregroundStyle(Color.appTextPrimary)
            
            Text(message)
                .font(.body)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .spacingXL)
            
            Button("Retry") {
                Task { await loadVenues() }
            }
            .buttonStyle(AppButtonStyle())
        }
    }
    
    // MARK: - Helpers
    
    private func loadVenues() async {
        guard viewModel.viewState != .loading else { return }
        guard let location = locationService.currentLocation else { return }
        await viewModel.loadVenues(latitude: location.latitude, longitude: location.longitude)
    }
}
