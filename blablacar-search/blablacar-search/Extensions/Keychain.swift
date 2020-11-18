//
//  Keychain.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import UIKit
import KeychainAccess

extension Keychain {
    
    enum Keys: String {
        case token
    }
    
    // auth token
    func token() -> String {
        if let token = self[Keys.token.rawValue] {
            return token
        } else {
            return ""
        }
    }
    
    func setToken(token: String) {
        self[Keys.token.rawValue] = token
    }
    
    func removeToken() {
        self[Keys.token.rawValue] = nil
    }
}
