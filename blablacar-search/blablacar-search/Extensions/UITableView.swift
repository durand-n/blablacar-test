//
//  UITableView.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: name)) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, reuseId: String) -> T {
        return dequeueReusableCell(withIdentifier: reuseId) as! T
    }
    
    func registerCellClass<T: UITableViewCell>(_ className: T.Type) {
        register(className, forCellReuseIdentifier: String(describing: className))
    }
    
}

extension UICollectionView {
    func registerCellClass<T: UICollectionViewCell>(_ className: T.Type) {
        register(className, forCellWithReuseIdentifier: String(describing: className))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as! T
    }
    
    func reloadWithAnimation() {
        self.reloadData()
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            for view in cell.contentView.subviews {
                view.alpha = 0
                view.transform = CGAffineTransform(translationX: 0, y: 20)
                UIView.animate(withDuration: 1.3, delay: 0.08 * Double(delayCounter), usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    view.transform = CGAffineTransform.identity
                    view.alpha = 1.0
                }, completion: nil)
                delayCounter += 1
            }
        }
    }
}
