//
//  AppConfig.swift
//  TEG Ticket App
//
//  Created by Igor  Vojinovic on 15/02/2026.
//

import Foundation

// MARK: - App Configuration

//Security Note Coding Challenge Only: API keys and authentication tokens are loaded from .xcconfig.
//In a production environment, secrets should be injected through: CI/CD pipeline secret variables (GitHub Actions, Bitrise, Xcode Cloud), Keychain for user-specific tokens obtained post-authentication...
//The xcconfig approach used here is suitable for local development and this coding challenge, but would not be used for production distribution.

public extension Bundle {
    
    // MARK: - Config Dictionary
    
    class var config: NSDictionary {
        guard let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? NSDictionary else {
            fatalError("Missing 'Config' dictionary in Info.plist. Ensure .xcconfig is properly linked.")
        }
        return config
    }
    
    // MARK: - Base URL
    
    @objc class var baseURL: String {
        guard let baseURL = config["BaseURL"] as? String, !baseURL.isEmpty else {
            fatalError("Missing 'BaseURL' in Config. Check your .xcconfig file.")
        }
        return baseURL
    }
    
    // MARK: - API Key
    
    class var apiKey: String {
        guard let apiKey = config["ApiKey"] as? String, !apiKey.isEmpty else {
            fatalError("Missing 'ApiKey' in Config. Check your .xcconfig file.")
        }
        return apiKey
    }
    
    // MARK: - API Auth
    
    class var apiAuth: String {
        guard let apiAuth = config["ApiAuth"] as? String, !apiAuth.isEmpty else {
            fatalError("Missing 'ApiAuth' in Config. Check your .xcconfig file.")
        }
        return apiAuth
    }
}
