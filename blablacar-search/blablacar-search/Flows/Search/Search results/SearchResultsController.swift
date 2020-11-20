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
    private var emptyLabel = UILabel(title: "Aucun résultat", type: .semiBold, color: .gray, size: 16, lines: 1, alignment: .center)
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var isLoading = false
    private var isDone = false
    
    // MARK: - Lifecycle
    init(viewModel: SearchResultsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.onInsert = self.didInsert
        
        self.viewModel.onDone = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
                self?.isLoading = false
            }
            self?.isDone = true
        }
        
        self.viewModel.onShowError = { [weak self] message in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
                self?.isLoading = false
            }
            self?.showError(message: message)
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .sand
        title = "Trajets"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .sand
        tableView.registerCellClass(TripCell.self)
        
        view.addSubviews([tableView, emptyLabel])
        
        tableView.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { cm in
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
        let rowCount = viewModel.resultsCount
        if rowCount == 0 {
            emptyLabel.fadeIn()
        } else {
            emptyLabel.fadeOut()
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TripCell.self)
        if let content = viewModel.getContentFor(row: indexPath.row) {
            cell.setContent(content)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isDone else { return }
        if indexPath.row == viewModel.resultsCount - 1, !isLoading {
            isLoading = true
            spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 70)
            spinner.startAnimating()

            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewModel.fetchNextTrips()
            }
        }
    }
    
    func didInsert(_ rowCount: Int) {
        guard rowCount > 0 else { return }
        DispatchQueue.main.async {
            let startIndex = self.tableView.numberOfRows(inSection: 0)
            var indexs = [IndexPath]()
            for index in startIndex...(startIndex+rowCount - 1) {
                indexs.append(IndexPath(row: index, section: 0))
            }
            self.tableView.insertRows(at: indexs, with: .automatic)
            self.tableView.tableFooterView = nil
            self.isLoading = false
        }
    }
}
