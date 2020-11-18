//
//  SearchCoordinator.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import UIKit

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
        let module = factory.makeSearchController(viewModel: SearchFormViewModel())
        module.onShowResults = showResults(trips:)
        
        self.router.push(module)
    }
    

    
    func showResults(trips: [BlaBlaApiModel.TripSearchResults.Trip]) {
        let module = factory.makeSearchResultsController(viewModel: SearchResultsViewModel(trips: trips))
        self.router.push(module)
    }
}
