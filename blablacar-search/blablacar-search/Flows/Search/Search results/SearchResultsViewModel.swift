//
//  SearchResultsViewModel.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import Foundation

// MARK: - Protocol definition
protocol SearchResultsViewModelType {
    var resultsCount: Int { get }
}

// MARK: - Protocol implementation
class SearchResultsViewModel: SearchResultsViewModelType {
    
    init() {}
    
    var resultsCount: Int {
        return 10
    }
}
