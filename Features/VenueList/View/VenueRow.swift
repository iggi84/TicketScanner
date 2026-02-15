//
//  VenueRow.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//
import SwiftUI

struct VenueRow: View {
    
    let venue: Venue
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: .spacingM) {
                Image(systemName: "building.2.fill")
                    .font(.title3)
                    .foregroundStyle(Color.appAccent)
                    .frame(width: .iconM)
                
                VStack(alignment: .leading, spacing: .spacingXS) {
                    Text(venue.name ?? "Unknown Venue")
                        .font(.headline)
                        .foregroundStyle(Color.appTextPrimary)
                    
                    if !venue.formattedLocation.isEmpty {
                        Text(venue.formattedLocation)
                            .font(.subheadline)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
            .padding(.spacingM)
            .background(Color.appSurface)
            .cornerRadius(.cornerRadiusM)
        }
    }
}
