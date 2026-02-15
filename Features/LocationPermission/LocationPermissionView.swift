//
//  LocationPermissionView.swift
//  TEG Ticket App
//
//  Created by Igor Vojinovic on 15/02/2026.
//

import SwiftUI

struct LocationPermissionView: View {
    
    let locationService: LocationService
    let onPermissionGranted: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: .spacingXL) {
                Spacer()
                
                Image(systemName: "location.circle.fill")
                    .font(.system(size: .iconXL))
                    .foregroundStyle(Color.appAccent)
                
                Text("Location Access")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("We need your location to find nearby venues for ticket scanning.")
                    .font(.body)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .spacingXL)
                
                if locationService.isDenied {
                    // Location denied — guide user to Settings
                    VStack(spacing: .spacingM) {
                        Text("Location access was denied. Please enable it in Settings.")
                            .font(.callout)
                            .foregroundStyle(Color.appError)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, .spacingXL)
                        
                        Button("Open Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .buttonStyle(AppButtonStyle())
                    }
                } else {
                    Button("Allow Location") {
                        locationService.requestPermission()
                    }
                    .buttonStyle(AppButtonStyle())
                }
                
                Spacer()
            }
        }
        .onChange(of: locationService.isAuthorized) { _, isAuthorized in
            if isAuthorized {
                onPermissionGranted()
            }
        }
    }
}

// MARK: - App Button Style

struct AppButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.spacingM)
            .background(Color.appAccent)
            .cornerRadius(.cornerRadiusM)
            .padding(.horizontal, .spacingXL)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
