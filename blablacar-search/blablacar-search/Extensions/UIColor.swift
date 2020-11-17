//
//  UIColor.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit

extension UIColor {
    class var background: UIColor { return #colorLiteral(red: 0.03689119965, green: 0.02587126754, blue: 0.1479471922, alpha: 1) }
    class var sand: UIColor { return #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1) }
    class var primary: UIColor { return #colorLiteral(red: 0.631372549, green: 0.8588235294, blue: 0.9607843137, alpha: 1) }
    class var secondary: UIColor { return #colorLiteral(red: 0.2431372549, green: 0.2705882353, blue: 0.6666666667, alpha: 1) }
    class var text: UIColor { return #colorLiteral(red: 0.3382632732, green: 0.368088156, blue: 0.5840685964, alpha: 1) }
    class var urgent: UIColor { return #colorLiteral(red: 0.8430811216, green: 0.2207605541, blue: 0.3205709755, alpha: 1) }
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}