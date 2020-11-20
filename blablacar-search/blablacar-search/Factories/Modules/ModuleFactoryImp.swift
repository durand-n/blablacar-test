//
//  ModuleFactoryImp.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import Foundation

final class ModuleFactoryImp {}


extension ModuleFactoryImp: SearchModuleFactory {
    func makeSearchController(viewModel: SearchFormViewModelType) -> SearchFormView {
        return SearchFormController(viewModel: viewModel)
    }
    
    func makeSearchResultsController(viewModel: SearchResultsViewModelType) -> SearchResultsView {
        return SearchResultsController(viewModel: viewModel)
    }
    
    func makeLocationSearchController(viewModel: LocationSearchViewModelType) -> LocationSearchView {
        return LocationSearchController(viewModel: viewModel)
    }
}
