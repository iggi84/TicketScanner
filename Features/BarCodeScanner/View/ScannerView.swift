//
//  ScannerView.swift
//  TEG Ticket App
//
//  Created by Igor Vojinovic on 15/02/2026.
//

import SwiftUI

struct ScannerView: View {
    
    let onBack: () -> Void
    
    @State private var viewModel: ScannerViewModel
    
    // MARK: - Init
    
    init(venue: Venue, onBack: @escaping () -> Void) {
        self._viewModel = State(initialValue: ScannerViewModel(venue: venue))
        self.onBack = onBack
    }
    
    var body: some View {
        ZStack {
            cameraLayer
    
            VStack(spacing: 0) {
                headerBar
                
                Spacer()
                
                if viewModel.scanState == .scanning {
                    scanTargetGuide
                    Spacer()
                }
            }
            
            if viewModel.scanState != .scanning {
                stateOverlay
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onDisappear {
            viewModel.cancelResume()
        }
    }
    
    // MARK: - Camera Layer
    
    @ViewBuilder
    private var cameraLayer: some View {
        if BarcodeScannerView.isSupported {
            BarcodeScannerView(isScanning: $viewModel.isScanning) { barcode in
                viewModel.handleBarcodeDetected(barcode)
            }
            .ignoresSafeArea()
        } else {
            cameraUnavailableView
        }
    }
    
    // MARK: - Header Bar
    
    private var headerBar: some View {
        VStack(spacing: .spacingS) {
            
            HStack {
                Button(action: onBack) {
                    HStack(spacing: .spacingXS) {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                        Text("Venues")
                    }
                    .foregroundStyle(.white)
                }
                Spacer()
            }
            
          
            Text(viewModel.venue.name ?? "Scanner")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, .spacingM)
        .padding(.vertical, .spacingS)
        .background(
            LinearGradient(
                colors: [.black.opacity(0.6), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
        )
    }
    
    // MARK: - Scan Target Guide
    
    private var scanTargetGuide: some View {
        RoundedRectangle(cornerRadius: .cornerRadiusM)
            .strokeBorder(Color.appAccent.opacity(0.8), lineWidth: 2)
            .frame(width: 280, height: 160)
            .overlay(
                // Corner accents
                ZStack {
                    CornerAccent(corner: .topLeft)
                    CornerAccent(corner: .topRight)
                    CornerAccent(corner: .bottomLeft)
                    CornerAccent(corner: .bottomRight)
                }
            )
    }
    
    // MARK: - State Overlay
    
    @ViewBuilder
    private var stateOverlay: some View {
        switch viewModel.scanState {
        case .scanning:
            EmptyView()
            
        case .processing:
            processingOverlay
            
        case .result(let success, let message):
            resultOverlay(success: success, message: message)
            
        case .error(let message):
            resultOverlay(success: false, message: message)
        }
    }
    
    // MARK: - Processing Overlay
    
    private var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            ProgressView()
                .controlSize(.large)
                .tint(.white)
        }
    }
    
    // MARK: - Result Overlay
    
    private func resultOverlay(success: Bool, message: String) -> some View {
        ZStack {
            (success ? Color.appSuccess.opacity(0.15) : Color.appError.opacity(0.15))
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            
            VStack(spacing: .spacingL) {
                Spacer()
                
                Image(systemName: success ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(success ? Color.appSuccess : Color.appError)
                
                Text(success ? "Entry Approved" : "Entry Denied")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(message)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .spacingXL)
                
                Spacer()
                
                Button("Scan Next Ticket") {
                    viewModel.resumeScanning()
                }
                .buttonStyle(AppButtonStyle())
                .padding(.bottom, .spacingXL)
            }
        }
    }
    
    // MARK: - Camera Unavailable
    
    private var cameraUnavailableView: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: .spacingL) {
                Image(systemName: "camera.fill")
                    .font(.system(size: .iconL))
                    .foregroundStyle(Color.appTextSecondary)
                
                Text("Camera Not Available")
                    .font(.headline)
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("Barcode scanning requires a device with a camera.")
                    .font(.body)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .spacingXL)
            }
        }
    }
}

// MARK: - Corner Accent

private struct CornerAccent: View {
    
    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    let corner: Corner
    private let length: CGFloat = 24
    private let thickness: CGFloat = 3
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let (x, y) = origin(in: geo.size)
                let (dx, dy) = direction
                
                path.move(to: CGPoint(x: x, y: y + dy * length))
                path.addLine(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + dx * length, y: y))
            }
            .stroke(Color.appAccent, lineWidth: thickness)
        }
    }
    
    private func origin(in size: CGSize) -> (CGFloat, CGFloat) {
        switch corner {
        case .topLeft:     return (0, 0)
        case .topRight:    return (size.width, 0)
        case .bottomLeft:  return (0, size.height)
        case .bottomRight: return (size.width, size.height)
        }
    }
    
    private var direction: (CGFloat, CGFloat) {
        switch corner {
        case .topLeft:     return (1, 1)
        case .topRight:    return (-1, 1)
        case .bottomLeft:  return (1, -1)
        case .bottomRight: return (-1, -1)
        }
    }
}
