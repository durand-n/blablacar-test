//
//  Services.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import Foundation

class Services {
    static let shared = Services()
    
    var blablaApi: BlaBlaApi = BlaBlaApiImp()
}

struct ApiError {
    /// Error code received from the server
    let type: String?
    let code: Int?
    /// Error message received from the server
    let message: String?
    
    init?(type: String?, message: String?) {
        self.type = type
        self.message = message
        if type == "SECURITY_UNAUTHORIZED" {
            self.code = 401
        } else {
            self.code = nil
        }
    }
    
    init?(code: Int?) {
        self.type = nil
        self.message = nil
        self.code = 400
    }
}
