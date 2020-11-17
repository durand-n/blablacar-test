//
//  ModuleFactory.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import Foundation

protocol SearchModuleFactory {
    func makeSearchController(viewModel: SearchModuleViewModelType) -> SearchModuleView
    func makeSearchResultsController(viewModel: SearchResultsViewModelType) -> SearchResultsView
}
