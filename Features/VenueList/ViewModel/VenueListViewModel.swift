//
//  VenueListViewModel.swift
//  TEG Ticket App
//
//  Created by Igor Vojinovic on 15/02/2026.
//

import Foundation

@Observable
final class VenueListViewModel {
    
    // MARK: - Properties
    
    var venues: [Venue] = []
    var viewState: ViewState = .idle
    
    private let repository: VenueRepository
    
    // MARK: - Init
    
    init(repository: VenueRepository = VenueRepositoryImpl()) {
        self.repository = repository
    }
    
    // MARK: - Load Venues
    
    func loadVenues(latitude: Double, longitude: Double) async {
        viewState = .loading
        
        do {
            let result = try await repository.fetchVenues(latitude: latitude, longitude: longitude)
            venues = result
            viewState = .loaded
        } catch let error as NetworkError {
            viewState = .error(error.localizedDescription)
        } catch {
            viewState = .error("Failed to load venues. Please try again.")
        }
    }
}
