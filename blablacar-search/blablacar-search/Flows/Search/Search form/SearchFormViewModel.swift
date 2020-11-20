//
//  SearchModuleViewModel.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import Foundation
import MapKit

// MARK: - Protocol definition
protocol SearchFormViewModelType {
    var onShowError: ((_ message: String, _ canRetry: Bool) -> Void)? { get set }
    var onFieldsUpdate: (() -> Void)? { get set }
    var onGetAccessToken: (() -> Void)? { get set }
    func refreshToken()
    func getTrips(completion: @escaping (_ trips: [BlaBlaApiModel.TripSearchResults.Trip]?, _ error: String?) -> Void)
    func setStartWayPoint(text: String, coordinates: CLLocationCoordinate2D?)
    func setDestinationWayPoint(text: String, coordinates: CLLocationCoordinate2D?)
    
    var startAddress: String { get }
    var destinationAddress: String { get }
}

// MARK: - Protocol implementation
class SearchFormViewModel: SearchFormViewModelType {
    // MARK: - Controlers delegates
    var onShowError: ((String, Bool) -> Void)?
    var onGetAccessToken: (() -> Void)?
    var onFieldsUpdate: (() -> Void)?
    
    // MARK: - private properties
    private var startWayPoint: (text: String, location: CLLocationCoordinate2D?) = ("Paris", nil)
    private var destinationWayPoint: (text: String, location: CLLocationCoordinate2D?) = ("Toulouse", nil)
    
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
    
    func setStartWayPoint(text: String, coordinates: CLLocationCoordinate2D?) {
        startWayPoint = (text, coordinates)
        onFieldsUpdate?()
    }
    
    func setDestinationWayPoint(text: String, coordinates: CLLocationCoordinate2D?) {
        destinationWayPoint = (text, coordinates)
        onFieldsUpdate?()
    }
    
    var startAddress: String {
        return startWayPoint.text
    }
    
    var destinationAddress: String {
        return destinationWayPoint.text
    }
    
}
