//
//  SearchResultsViewModel.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import UIKit

typealias Trip = BlaBlaApiModel.TripSearchResults.Trip

// MARK: - Protocol definition
protocol SearchResultsViewModelType {
    var resultsCount: Int { get }
    
    func getContentFor(row: Int) -> TripCellDataRepresentable?
}

// MARK: - Protocol implementation
class SearchResultsViewModel: SearchResultsViewModelType {
    
    private var trips: [Trip]
    
    init(trips: [Trip]) {
        self.trips = trips
    }
    
    var resultsCount: Int {
        return trips.count
    }
    
    func getContentFor(row: Int) -> TripCellDataRepresentable? {
        guard row < trips.count  else { return nil }
        let trip = trips [row]
        guard let start = trip.waypoints.first, let end = trip.waypoints.last else { return nil }
        
        let representable = TripCellDataRepresentable(start: getWaypointAttributed(waypoint: start), destination: getWaypointAttributed(waypoint: end), driver: trip.driver.name, driverPicture: URL(string: trip.driver.thumbnail))
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
}

struct TripCellDataRepresentable {
    var start: NSAttributedString
    var destination: NSAttributedString
    var driver: String
    var driverPicture: URL?
}
