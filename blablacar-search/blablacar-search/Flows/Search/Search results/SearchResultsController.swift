//
//  SearchResultsController.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import UIKit

protocol SearchResultsView: BaseView {
    
}

class SearchResultsController: UIViewController, SearchResultsView {
    // MARK: - Protocol compliance
    
    // MARK: - Properties
    private var viewModel: SearchResultsViewModelType
    private var tableView = UITableView()
    
    // MARK: - Lifecycle
    init(viewModel: SearchResultsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Tableview delegates and datasource

extension SearchResultsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
