//
//  SearchModuleController.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import UIKit
import MapKit

protocol SearchFormView: BaseView {
    var onShowResults: ((BlaBlaApiModel.TripSearchResults, (String, String, TripSearchType)) -> Void)? { get set }
    var onSelectStartWith: ((_ address: String?) -> Void)? { get set }
    var onSelectDesinationWith: ((_ address: String?) -> Void)? { get set }
}

class SearchFormController: UIViewController, SearchFormView {
    
    // MARK: - Protocol compliance
    var onShowResults: ((BlaBlaApiModel.TripSearchResults, (String, String, TripSearchType)) -> Void)?
    var onSelectStartWith: ((String?) -> Void)?
    var onSelectDesinationWith: ((String?) -> Void)?
    
    // MARK: - Properties
    
    private var viewModel: SearchFormViewModelType
    private let destinationField = UITextField(backgroundColor: .white)
    private let departureField = UITextField(backgroundColor: .white)
    // MARK: - Lifecycle
    
    init(viewModel: SearchFormViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.onShowError = showError
        self.viewModel.onGetAccessToken = {
            Loader.hide()
        }
        
        self.viewModel.onFieldsUpdate = { [weak self] in
            self?.departureField.text = viewModel.startAddress
            self?.destinationField.text = viewModel.destinationAddress
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designView()
        Loader.show()
        self.viewModel.refreshToken()
    }
    
    // MARK: - Design
    
    func designView() {
        view.backgroundColor = .white
        let cardContainer = UIView(backgroundColor: .primary)
        let departureLabel = UILabel(title: "Départ", type: .medium, color: .black, size: 14, lines: 1, alignment: .left)
        let destinationLabel = UILabel(title: "Arrivée", type: .medium, color: .black, size: 14, lines: 1, alignment: .left)
        let searchButton = UIButton(title: "Rechercher", font: .bold, fontSize: 16, textColor: .white, backgroundColor: .secondary)
        
        departureField.cornerRadius = 8
        departureField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        departureField.tag = 0
        departureField.delegate = self
        destinationField.cornerRadius = 8
        destinationField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        destinationField.tag = 1
        destinationField.delegate = self
        searchButton.addTarget(self, action: #selector(searchPushed), for: .touchUpInside)
        departureField.text = viewModel.startAddress
        destinationField.text = viewModel.destinationAddress
        
        // MARK: - View constraints
        
        view.addSubviews([cardContainer])
        cardContainer.addSubviews([departureLabel, departureField, destinationLabel, destinationField, searchButton])
        
        cardContainer.snp.makeConstraints { cm in
            cm.top.equalToSuperview().offset(80)
            cm.left.right.equalToSuperview().inset(32)
            cardContainer.cornerRadius = 12
            
            departureLabel.snp.makeConstraints { cm in
                cm.top.equalToSuperview().offset(30)
                cm.left.right.equalToSuperview().inset(20)
            }
            
            departureField.snp.makeConstraints { cm in
                cm.top.equalTo(departureLabel.snp.bottom).offset(3)
                cm.left.right.equalToSuperview().inset(16)
                cm.height.equalTo(30)
            }
            
            destinationLabel.snp.makeConstraints { cm in
                cm.top.equalTo(departureField.snp.bottom).offset(24)
                cm.left.right.equalToSuperview().inset(20)
            }
            
            destinationField.snp.makeConstraints { cm in
                cm.top.equalTo(destinationLabel.snp.bottom).offset(3)
                cm.left.right.equalToSuperview().inset(16)
                cm.height.equalTo(30)
            }
            
            searchButton.snp.makeConstraints { cm in
                cm.top.equalTo(destinationField.snp.bottom).offset(50)
                cm.left.right.equalToSuperview().inset(16)
                cm.height.equalTo(50)
                cm.bottom.equalToSuperview().offset(-16)
                searchButton.cornerRadius = 25
            }
        }
    }
    
    @objc func searchPushed() {
        Loader.show()
        viewModel.getTrips { (data, request, error) in
            Loader.hide()
            if let data = data {
                self.onShowResults?(data, request)
            } else {
                self.showError(message: error ?? "Une erreur est survenue")
            }
        }
    }
    
    func showError(message: String, canRetry: Bool) {
        Loader.hide()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Une erreur est survenue", message: message, preferredStyle: .alert)
            let retry = UIAlertAction(title: "Réessayer", style: .default) { _ in
                Loader.show()
                self.viewModel.refreshToken()
            }
            let close = UIAlertAction(title: "Fermer", style: .default, handler: nil)
            alert.addAction(canRetry ? retry : close)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension SearchFormController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.tag == 0 ? self.onSelectStartWith?(textField.text) : self.onSelectDesinationWith?(textField.text)
    }
}
