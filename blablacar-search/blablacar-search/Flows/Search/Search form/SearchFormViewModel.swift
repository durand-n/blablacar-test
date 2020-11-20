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
    func getTrips(completion: @escaping (_ trips: BlaBlaApiModel.TripSearchResults?, _ request: (from: String, to: String, type: TripSearchType), _ error: String?) -> Void)
    func setStartWayPoint(address: String, fullAddress: String, coordinates: CLLocationCoordinate2D?)
    func setDestinationWayPoint(address: String, fullAddress: String, coordinates: CLLocationCoordinate2D?)
    
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
    private var startWayPoint: (address: String, fullAddress: String, location: CLLocationCoordinate2D?) = ("Paris", "Paris, France", nil)
    private var destinationWayPoint: (address: String, fullAddress: String, location: CLLocationCoordinate2D?) = ("Toulouse", "Toulouse, France", nil)
    
    // MARK: - Controller properties/methods
    
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
    
    func getTrips(completion: @escaping (BlaBlaApiModel.TripSearchResults?, (from: String, to: String, type: TripSearchType), String?) -> Void) {
        var from = startWayPoint.address
        var to = destinationWayPoint.address
        var type = TripSearchType.Address
        
        if let fromCoordinates = startWayPoint.location, let toCoordinates = destinationWayPoint.location {
            type = TripSearchType.Coordinates
            from = "\(fromCoordinates.latitude),\(fromCoordinates.longitude)"
            to = "\(toCoordinates.latitude),\(toCoordinates.longitude)"
        }
        
        Services.shared.blablaApi.getTrips(from: from, to: to, type: type, cursor: nil) { (result, error) in
            if let result = result {
                completion(result, (from, to , type), nil)
            } else {
                if error?.code == 401 {
                    self.refreshToken()
                }
                completion(nil, (from, to , type), "Une erreur est survenue, merci de réessayer")
            }
        }
    }
    
    func getTrips(completion: @escaping (_ trips: BlaBlaApiModel.TripSearchResults?, _ error: String?) -> Void) {

    }
    
    func setStartWayPoint(address: String, fullAddress: String, coordinates: CLLocationCoordinate2D?) {
        startWayPoint = (address, fullAddress, coordinates)
        onFieldsUpdate?()
    }
    
    func setDestinationWayPoint(address: String, fullAddress: String, coordinates: CLLocationCoordinate2D?) {
        destinationWayPoint = (address, fullAddress, coordinates)
        onFieldsUpdate?()
    }
    
    var startAddress: String {
        return startWayPoint.fullAddress
    }
    
    var destinationAddress: String {
        return destinationWayPoint.fullAddress
    }
    
}
