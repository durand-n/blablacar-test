//
//  SearchResultsViewModel.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import UIKit
import MapKit

typealias Trip = BlaBlaApiModel.TripSearchResults.Trip

// MARK: - Protocol definition
protocol SearchResultsViewModelType {
    var onInsert: ((Int) -> Void)? { get set }
    var onDone: (() -> Void)? { get set }
    var onShowError: ((String) -> Void)? { get set }
    var resultsCount: Int { get }
    
    func getContentFor(row: Int) -> TripCellDataRepresentable?
    func fetchNextTrips()
}

class SearchResultsViewModel: SearchResultsViewModelType {
    // MARK: - Protocol compliance
    var onShowError: ((String) -> Void)?
    var onInsert: ((Int) -> Void)?
    var onDone: (() -> Void)?
    
    // MARK: - Private properties
    private var trips: [Trip]
    private var cursor: String?
    private let request: (from: String, to: String, type: TripSearchType)
    
    // MARK: - Init
    init(data: BlaBlaApiModel.TripSearchResults, request: (String, String, TripSearchType)) {
        self.trips = data.trips
        self.cursor = data.pagination.nextCursor
        self.request = request
    }
    
    // MARK: - Controller related methods/properties
    var resultsCount: Int {
        return trips.count
    }
    
    func getContentFor(row: Int) -> TripCellDataRepresentable? {
        guard row < trips.count  else { return nil }
        let trip = trips [row]
        guard let start = trip.waypoints.first, let end = trip.waypoints.last else { return nil }
        
        let representable = TripCellDataRepresentable(startDate: start.dateTime.string(withFormat: "EE dd MMM"), start: getWaypointAttributed(waypoint: start), destination: getWaypointAttributed(waypoint: end), driver: trip.driver.name, driverPicture: URL(string: trip.driver.thumbnail), price: trip.monetizationPrice.monetizedPrice.formattedPrice)
        return representable
    }
    
    func getWaypointAttributed(waypoint: BlaBlaApiModel.TripSearchResults.Waypoint) -> NSAttributedString {
        let date = waypoint.dateTime.string(withFormat: "HH:mm")
        let formatted = date + " - " + waypoint.mainText
        let attributed = NSMutableAttributedString.init(string: formatted)
        let range = (formatted as NSString).range(of: date)
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        attributed.addAttribute(NSAttributedString.Key.font, value: FontType.bold.getFontWithSize(14), range: range)
        
        return attributed
    }
    
    func fetchNextTrips() {
        if let cursor = cursor {
            Services.shared.blablaApi.getTrips(from: request.from, to: request.to, type: request.type, cursor: cursor) { (result, error) in
                if let result = result {
                    self.trips.append(contentsOf: result.trips)
                    self.cursor = result.pagination.nextCursor
                    self.onInsert?(result.trips.count)
                } else {
                    if error?.code == 401 {
                        self.refreshToken()
                        self.onShowError?("Merci de réessayer")
                    } else {
                        self.onShowError?(error?.message ?? "Une erreur est survenue")
                    }
                }
            }
        } else {
            self.onDone?()
        }
    }
    
    func refreshToken() {
        Services.shared.blablaApi.getToken { (token, error) in
            if let token = token {
                keychain.setToken(token: token)
            }
        }
    }
}

//MARK: - TripCellDataRepresentable
struct TripCellDataRepresentable {
    var startDate: String
    var start: NSAttributedString
    var destination: NSAttributedString
    var driver: String
    var driverPicture: URL?
    var price: String
}
