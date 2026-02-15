//
//  SplashView.swift
//  TEG Ticket App
//
//  Created by Igor Vojinovic on 15/02/2026.
//

import SwiftUI

struct SplashView: View {
    
    let onComplete: () -> Void
    
    @State private var logoOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: .spacingL) {
                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                
                Text("TEG Access Control")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("Ticket Scanner")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            }
            .opacity(logoOpacity)
        }
        .task {
            withAnimation(.easeIn(duration: 0.6)) {
                logoOpacity = 1
            }
            try? await Task.sleep(for: .seconds(2))
            onComplete()
        }
    }
}
