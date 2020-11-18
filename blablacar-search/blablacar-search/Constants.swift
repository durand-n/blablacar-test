//
//  Constants.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import Foundation
import UIKit
import KeychainAccess

let keychain = Keychain(service: "io.cleanfox.ios")

struct Constants {
    static let SERVER_URL = "https://edge.blablacar.com"
    static let CLIENT_SECRET = "rVSUYoebg6zbZxYNxGOGAxv09oSi3gGg"
    static let CLIENT_ID = "ios-technical-tests"
}

struct Loader {
    static let contentView = UIView(backgroundColor: UIColor.black.withAlphaComponent(0.5))
    static let spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    static func show() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            window.addSubviews([contentView, spinner])
            spinner.startAnimating()
            contentView.snp.makeConstraints { cm in
                cm.edges.equalToSuperview()
            }
            spinner.snp.makeConstraints { cm in
                cm.center.equalToSuperview()
                cm.size.equalTo(80)
            }
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            contentView.removeFromSuperview()
            spinner.removeFromSuperview()
        }
    }
}
