//
//  LocationSearchController.swift
//  blablacar-search
//
//  Created by Benoît Durand on 19/11/2020.
//

import UIKit
import MapKit

protocol LocationSearchView: BaseView {
    var didFinishWith: ((_ address: String, _ fullAddress: String, _ location: CLLocationCoordinate2D?) -> Void)? { get set }
    var didCancel: (() -> Void)? { get set }
}

class LocationSearchController: UIViewController, LocationSearchView {
    // MARK: - Protocol compliance
    var didFinishWith: ((_ address: String, _ fullAddress: String, _ location: CLLocationCoordinate2D?) -> Void)?
    var didCancel: (() -> Void)?
    
    // MARK: - private properties
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar
    private var tableView = UITableView(backgroundColor: .white)
    private var emptyLabel = UILabel(title: "Aucun résultat", type: .semiBold, color: .gray, size: 16, lines: 1, alignment: .center)
    private var viewModel: LocationSearchViewModelType
    
    // MARK: - Lifecycle
    init(viewModel: LocationSearchViewModelType) {
        searchBar = searchController.searchBar
        self.viewModel = viewModel
        searchBar.text = viewModel.fieldInit
        super.init(nibName: nil, bundle: nil)
        overrideUserInterfaceStyle = .light
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didFinishWith = self.didFinishWith
        viewModel.shouldReloadData = tableView.reloadData
        view.backgroundColor = .white
        emptyLabel.backgroundColor = .white
        searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchBar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellClass(LocationSearchCell.self)
        view.addSubviews([tableView, emptyLabel])
        
        tableView.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
        viewModel.updateResults(query: searchBar.text ?? "")
    }
}

extension LocationSearchController: UISearchBarDelegate {}

extension LocationSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateResults(query: searchBar.text ?? "")
    }
}

extension LocationSearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = viewModel.itemCount
        if rowCount == 0 {
            emptyLabel.fadeIn()
        } else {
            emptyLabel.fadeOut()
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: LocationSearchCell.self)
        let selectedItem = viewModel.itemFor(indexPath.row)
        cell.textLabel?.text = selectedItem.title
        cell.detailTextLabel?.text = selectedItem.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItemAt(indexPath.row)
    }
}

class LocationSearchCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
