//
//  ModuleFactory.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import Foundation

protocol SearchModuleFactory {
    func makeSearchController(viewModel: SearchFormViewModelType) -> SearchFormView
    func makeSearchResultsController(viewModel: SearchResultsViewModelType) -> SearchResultsView
    func makeLocationSearchController(viewModel: LocationSearchViewModelType) -> LocationSearchView
}
