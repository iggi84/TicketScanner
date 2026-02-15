# TEG Ticket App — Access Control Scanner

A native iOS application for venue staff to scan and validate patron ticket barcodes at Ticketek events.

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/4b215024-6895-4258-8a75-0154beec78fe" alt="Splash" width="180" />
  <img src="https://github.com/user-attachments/assets/e764268a-22e6-41c8-a561-f4e8ce5f1d57" alt="Location" width="180" />
  <img src="https://github.com/user-attachments/assets/673a515b-323b-4841-b5d1-27c21bd0b832" alt="Venues" width="180" />
  <img src="https://github.com/user-attachments/assets/736e3975-07f9-4a2c-b384-77fe31faa6f0" alt="Scanner" width="180" />
  <img src="https://github.com/user-attachments/assets/90bc4e89-fa9b-431e-8854-4e896385e416" alt="Scan Result" width="180" />
</p>

## Architecture

The app follows **MVVM with a Repository pattern**. ViewModels handle presentation logic and communicate with the data layer through a `VenueRepository` protocol. This abstraction decouples ViewModels from the networking implementation, making it easy to inject mock repositories for unit testing or swap the network layer without touching any view code.

**Models** are simple `Decodable` structs with all properties marked as optional. The API documentation warns about potential "oddballs" in responses, so optional properties let the app handle missing or unexpected fields gracefully without crashing.

**Barcode scanning** uses Apple's `DataScannerViewController` from VisionKit, wrapped in a `UIViewControllerRepresentable` bridge. SwiftUI has no native camera view, so this UIKit bridge is required to present the live camera feed. `DataScannerViewController` handles camera setup, preview, and barcode detection internally, keeping our code minimal compared to a manual AVFoundation implementation.

No third-party dependencies are used — networking is built on native `URLSession`.

## API Outage Handling

Network errors are mapped to domain-specific `NetworkError` cases. HTTP 503 responses are mapped to `.serverOutage` specifically, and a computed `isRetryable` property identifies errors that warrant a retry (server outage, no internet, 5xx errors). The venue list and scanner views both display user-friendly error states with retry capability.

## Configuration

API credentials are stored in `Production.xcconfig` and injected into the app via `Info.plist` at build time. The `AppConfig.swift` file documents that this approach is used for simplicity in this coding challenge.

> [!WARNING]
> **Production apps should use a gitignored secrets file with CI/CD injection, remote configuration, or Keychain storage.**

## Requirements

- iOS 17.6+
- Xcode 16.2+
- Swift 5.0
- Physical device required (camera access for barcode scanning)

## Setup

1. Clone the repository
2. Open `TEG Ticket App.xcodeproj` in Xcode
3. Select a physical device as the run destination
4. Build and run (`Cmd+R`)

No additional setup or dependency installation required.
