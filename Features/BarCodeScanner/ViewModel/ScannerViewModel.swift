//
//  ScannerViewModel.swift
//  TEG Ticket App
//
//  Created by Igor Vojinovic on 15/02/2026.
//

import Foundation

// MARK: - Scan State

enum ScanState: Equatable {
    case scanning
    case processing
    case result(success: Bool, message: String)
    case error(String)
    
    static func == (lhs: ScanState, rhs: ScanState) -> Bool {
        switch (lhs, rhs) {
        case (.scanning, .scanning), (.processing, .processing):
            return true
        case (.result(let a1, let a2), .result(let b1, let b2)):
            return a1 == b1 && a2 == b2
        case (.error(let a), .error(let b)):
            return a == b
        default:
            return false
        }
    }
}

// MARK: - Scanner ViewModel

@Observable
final class ScannerViewModel {
    
    // MARK: - Properties
    
    var scanState: ScanState = .scanning
    var isScanning: Bool = true
    
    let venue: Venue
    
    private let repository: VenueRepository
    private var resumeTask: Task<Void, Never>?
    
    private let resumeDelay: TimeInterval = 5
    
    // MARK: - Init
    
    init(venue: Venue, repository: VenueRepository = VenueRepositoryImpl()) {
        self.venue = venue
        self.repository = repository
    }
    
    // MARK: - Barcode Detected
    
    func handleBarcodeDetected(_ barcode: String) {
        guard scanState == .scanning else { return }
        
        isScanning = false
        scanState = .processing
        
        Task {
            await validateTicket(barcode: barcode)
        }
    }
    
    // MARK: - Validate Ticket
    
    private func validateTicket(barcode: String) async {
        guard let venueCode = venue.code else {
            scanState = .error("Invalid venue configuration.")
            scheduleResume()
            return
        }
        
        do {
            let response = try await repository.scanTicket(venueCode: venueCode, barcode: barcode)
            scanState = .result(success: response.isSuccess, message: response.displayMessage)
        } catch let error as NetworkError {
            scanState = .error(error.localizedDescription)
        } catch {
            scanState = .error("Failed to validate ticket. Please try again.")
        }
        
        scheduleResume()
    }
    
    // MARK: - Auto-Resume
    
    private func scheduleResume() {
        resumeTask?.cancel()
        resumeTask = Task {
            try? await Task.sleep(for: .seconds(resumeDelay))
            guard !Task.isCancelled else { return }
            resumeScanning()
        }
    }
    
    func resumeScanning() {
        scanState = .scanning
        isScanning = true
    }
    
    // MARK: - Cleanup
    
    func cancelResume() {
        resumeTask?.cancel()
    }
}
