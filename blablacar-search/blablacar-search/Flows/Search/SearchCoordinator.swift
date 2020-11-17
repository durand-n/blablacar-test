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
        let module = factory.makeSearchController(viewModel: SearchModuleViewModel())
        module.onShowResults = { [weak self] in
            guard let self = self else { return }
            self.showResults()
        }
        
        self.router.push(module)
    }
    
    func showResults() {
        
    }
}
