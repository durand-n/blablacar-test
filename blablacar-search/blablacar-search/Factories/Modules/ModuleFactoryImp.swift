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
    func makeSearchController(viewModel: SearchModuleViewModelType) -> SearchModuleView {
        return SearchModuleController(viewModel: viewModel)
    }
    
    func makeSearchResultsController(viewModel: SearchResultsViewModelType) -> SearchResultsView {
        return SearchResultsController(viewModel: viewModel)
    }
    
}
