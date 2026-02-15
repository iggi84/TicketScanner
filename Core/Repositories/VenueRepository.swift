//
//  VenueRepository.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

// MARK: - Repository Protocol

protocol VenueRepository: Sendable {
    func fetchVenues(latitude: Double, longitude: Double) async throws -> [Venue]
    func scanTicket(venueCode: String, barcode: String) async throws -> ScanResponse
}

// MARK: - Default Implementation

final class VenueRepositoryImpl: VenueRepository {
    
    // MARK: - Properties
    
    private let networkService: NetworkService
    
    // MARK: - Initialisation
    
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Fetch Venues
    
    func fetchVenues(latitude: Double, longitude: Double) async throws -> [Venue] {
        let endpoint = TicketekEndpoint.getVenues(latitude: latitude, longitude: longitude)
        let response: VenuesResponse = try await networkService.request(endpoint)
        return response.venues ?? []
    }
    
    // MARK: - Scan Ticket
    
    func scanTicket(venueCode: String, barcode: String) async throws -> ScanResponse {
        let endpoint = TicketekEndpoint.scanTicket(venueCode: venueCode, barcode: barcode)
        return try await networkService.request(endpoint)
    }
}
