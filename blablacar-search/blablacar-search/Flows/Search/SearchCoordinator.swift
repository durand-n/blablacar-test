//
//  SearchCoordinator.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import UIKit
import MapKit

class SearchCoordinator: BaseCoordinator {
    private let factory: SearchModuleFactory
    private let router: Router
    
    init(factory: SearchModuleFactory, router: Router) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        showSearchPage()
    }
    
    func showSearchPage() {
        let formViewModel = SearchFormViewModel()
        let module = factory.makeSearchController(viewModel: formViewModel)
        module.onShowResults = showResults(trips:)
        
        module.onSelectStartWith = { [weak self] start in
            self?.showLocationSearch(text: start ?? "", completion: { (text, coordinates) in
                formViewModel.setStartWayPoint(text: text, coordinates: coordinates)
            })
        }
        
        module.onSelectDesinationWith = { [weak self] destination in
            self?.showLocationSearch(text: destination ?? "", completion: { (text, coordinates) in
                formViewModel.setDestinationWayPoint(text: text, coordinates: coordinates)
            })
        }
        
        self.router.push(module)
    }
    
    func showLocationSearch(text: String, completion: @escaping ((_ text: String, _ coordinates: CLLocationCoordinate2D?) -> Void)) {
        let locationSearch: LocationSearchView = LocationSearchController(viewModel: LocationSearchViewModel(place: text))
        locationSearch.didFinishWith =  { placeString, coordinates in
            print("did finish with")
            completion(placeString, coordinates)
            self.router.dismissModule()
        }
        
        self.router.present(locationSearch)
    }

    
    func showResults(trips: [BlaBlaApiModel.TripSearchResults.Trip]) {
        let module = factory.makeSearchResultsController(viewModel: SearchResultsViewModel(trips: trips))
        self.router.push(module)
    }
}
