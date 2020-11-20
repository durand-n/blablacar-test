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
        module.onShowResults = { [weak self] data, request in
            self?.showResults(viewModel: SearchResultsViewModel(data: data, request: request))
        }
        
        module.onSelectStartWith = { [weak self] start in
            self?.showLocationSearch(text: start ?? "", completion: { (address, fullAddress, coordinates) in
                formViewModel.setStartWayPoint(address: address, fullAddress: fullAddress, coordinates: coordinates)
            })
        }
        
        module.onSelectDesinationWith = { [weak self] destination in
            self?.showLocationSearch(text: destination ?? "", completion: { (address, fullAddress, coordinates) in
                formViewModel.setDestinationWayPoint(address: address, fullAddress: fullAddress, coordinates: coordinates)
            })
        }
        
        self.router.push(module)
    }
    
    func showLocationSearch(text: String, completion: @escaping ((_ address: String, _ fullAddress: String, _ coordinates: CLLocationCoordinate2D?) -> Void)) {
        let module = factory.makeLocationSearchController(viewModel: LocationSearchViewModel(place: text))
        module.didFinishWith =  { placeString, fullAddress, coordinates in
            completion(placeString, fullAddress, coordinates)
            self.router.dismissModule()
        }
        
        self.router.present(module)
    }

    
    func showResults(viewModel: SearchResultsViewModelType) {
        let module = factory.makeSearchResultsController(viewModel: viewModel)
        self.router.push(module)
    }

}
