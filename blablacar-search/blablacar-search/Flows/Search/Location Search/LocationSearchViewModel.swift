//
//  LocationSearchViewModel.swift
//  blablacar-search
//
//  Created by Benoît Durand on 20/11/2020.
//

import Foundation
import MapKit

protocol LocationSearchViewModelType {
    var didFinishWith: ((_ address: String, _ fullAddress: String, _ location: CLLocationCoordinate2D?) -> Void)? { get set }
    var shouldReloadData: (() -> Void)? { get set }
    
    var itemCount: Int { get }
    var fieldInit: String { get }
    func itemFor(_ row: Int) -> (title: String, subtitle: String)
    func selectItemAt(_ row: Int)
    func updateResults(query: String)
}

class LocationSearchViewModel: NSObject, LocationSearchViewModelType {
    // MARK: - Protocol compliance
    var shouldReloadData: (() -> Void)?
    var didFinishWith: ((_ address: String, _ fullAddress: String, _ location: CLLocationCoordinate2D?) -> Void)?
    
    // MARK: - private properties
    private var matchingItems: [MKLocalSearchCompletion] = []
    private var searchCompleter = MKLocalSearchCompleter()
    
    
    init(place: String) {
        fieldInit = place
        super.init()
        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        self.updateResults(query: fieldInit)
    }
    
    // MARK: - Controller methods
    var fieldInit: String
    
    func updateResults(query: String) {
        searchCompleter.queryFragment = query
    }
    
    func selectItemAt(_ row: Int) {
        guard row < matchingItems.count else { return }
        let placeItem = self.matchingItems[row]
        let searchRequest = MKLocalSearch.Request(completion: placeItem)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let response = response, let coordinates = response.mapItems.first?.placemark.coordinate {
                self.didFinishWith?(placeItem.title, placeItem.title + ", " + placeItem.subtitle, coordinates)
            } else {
                self.didFinishWith?(placeItem.title, placeItem.title + ", " + placeItem.subtitle, nil)
            }
        }
    }
    
    func itemFor(_ row: Int) -> (title: String, subtitle: String) {
        let placeItem = self.matchingItems[row]
        return (placeItem.title, placeItem.subtitle)
    }
    
    var itemCount: Int {
        return matchingItems.count
    }
}

// MARK: - MKLocaleSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        matchingItems = completer.results
        self.shouldReloadData?()
     }
}
