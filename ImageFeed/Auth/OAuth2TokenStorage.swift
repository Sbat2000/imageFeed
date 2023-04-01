//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 19.03.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    private let tokenKey = "auth2_token"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
