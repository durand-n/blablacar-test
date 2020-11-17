//
//  UIImageView.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?, contentMode cm: UIView.ContentMode) {
        self.init(image: image)
        self.contentMode = cm
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.alpha = 1.0
                        self?.contentMode = .scaleAspectFit
                    }
                } else {
                    self?.setPlaceholder()
                }
            } else {
                self?.setPlaceholder()
            }
        }
    }
    
    func setPlaceholder() {
        DispatchQueue.main.async {
            self.image = #imageLiteral(resourceName: "noPicture")
            self.alpha = 0.1
        }
    }
}