//
//  BarcodeScannerView.swift
//  TEG Ticket App
//
//  Created by Igor Vojinovic on 15/02/2026.
//

import SwiftUI
import VisionKit

// MARK: - Barcode Scanner View

struct BarcodeScannerView: UIViewControllerRepresentable {
    
    @Binding var isScanning: Bool
    let onBarcodeDetected: (String) -> Void
    
    // MARK: - Availability Check
    
    static var isSupported: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    // MARK: - UIViewControllerRepresentable
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onBarcodeDetected: onBarcodeDetected)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            isGuidanceEnabled: false,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ scanner: DataScannerViewController, context: Context) {
        if isScanning {
            context.coordinator.reset()
            try? scanner.startScanning()
        } else {
            scanner.stopScanning()
        }
    }
    
    // MARK: - Coordinator
    
    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        let onBarcodeDetected: (String) -> Void
        private var hasDetected = false
        
        init(onBarcodeDetected: @escaping (String) -> Void) {
            self.onBarcodeDetected = onBarcodeDetected
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            
            guard !hasDetected else { return }
            
            guard case .barcode(let barcode) = addedItems.first,
                  let value = barcode.payloadStringValue,
                  !value.isEmpty else {
                return
            }
            
            hasDetected = true
            
           
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            onBarcodeDetected(value)
        }
        
        func reset() {
            hasDetected = false
        }
    }
}
