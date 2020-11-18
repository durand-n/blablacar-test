//
//  SearchModuleViewModel.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import Foundation

// MARK: - Protocol definition
protocol SearchFormViewModelType {
    var onShowError: ((_ message: String, _ canRetry: Bool) -> Void)? { get set }
    var onGetAccessToken: (() -> Void)? { get set }
    func refreshToken()
    func getTrips(completion: @escaping (_ trips: [BlaBlaApiModel.TripSearchResults.Trip]?, _ error: String?) -> Void)
}

// MARK: - Protocol implementation
class SearchFormViewModel: SearchFormViewModelType {
    // MARK: - Controlers delegates
    var onShowError: ((String, Bool) -> Void)?
    var onGetAccessToken: (() -> Void)?
    
    // MARK: - Controler's trigerred method
    
    func refreshToken() {
        Services.shared.blablaApi.getToken { (token, error) in
            if let token = token {
                keychain.setToken(token: token)
                self.onGetAccessToken?()
            } else {
                self.onShowError?("Merci de réessayer plus tard", true)
            }
        }
    }
    
    func getTrips(completion: @escaping (_ trips: [BlaBlaApiModel.TripSearchResults.Trip]?, _ error: String?) -> Void) {
        Services.shared.blablaApi.getTrips(from: "Paris", to: "Toulouse") { (trips, error) in
            if let trips = trips {
                completion(trips, nil)
            } else {
                completion(nil, error?.localizedDescription)
            }
        }
    }
    
}
