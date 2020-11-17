//
//  UIView.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit

extension UIView {
    
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    var cornerRadius: CGFloat? {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue ?? 0
            layer.masksToBounds = (newValue ?? CGFloat(0.0)) > CGFloat(0.0)
        }
    }
    
    func cornerRadius(usingCorners corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            layer.maskedCorners = corners
        }
    }
    
    open func addSubviews(_ views: [UIView]) {
        for i in 0..<views.count {
            addSubview(views[i])
        }
    }
    
    open func removeSubviews() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    open func fadeIn(withDuration: TimeInterval = 0.2, completion: ((Bool) -> Void)? = nil) {
        self.isHidden = false
        UIView.animate(withDuration: withDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    open func fadeOut(withDuration: TimeInterval = 0.2, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: withDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 0
        }, completion: { success in
            self.isHidden = true
            completion?(success)
        })
    }
        
    open func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    open func removeShadow() {
        layer.shadowOpacity = 0.0
    }
}

