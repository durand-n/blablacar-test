//
//  SearchModuleController.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import UIKit

protocol SearchModuleView: BaseView {
    var onShowResults: (() -> Void)? { get set }
}

class SearchModuleController: UIViewController, SearchModuleView {
    // MARK: - Protocol compliance
    var onShowResults: (() -> Void)?
    
    // MARK: - Properties
    
    private var viewModel: SearchModuleViewModelType
    
    // MARK: - Lifecycle
    
    init(viewModel: SearchModuleViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designView()
    }
    
    // MARK: - Design
    
    func designView() {
        view.backgroundColor = .white
    }
}
