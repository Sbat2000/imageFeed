//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 19.03.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let tokenKey = "auth2_token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {KeychainWrapper.standard.set(token, forKey: tokenKey)}
            
        }
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: tokenKey)
    }
}
