//
//  UILabel.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit

extension UILabel {
    convenience init(title: String? = nil, type: FontType, color: UIColor, size: CGFloat = 14.0, lines: Int = 1, alignment: NSTextAlignment? = nil) {
        self.init()
        self.text = title


        setDesign(type: type, color: color, size: size, lines: lines, alignment: alignment)
    }

    func setDesign(type: FontType, color: UIColor, size: CGFloat = 14.0, lines: Int = 1, alignment: NSTextAlignment? = nil) {
        if let alignment = alignment {
            self.textAlignment = alignment
        }
        self.font = type.getFontWithSize(size)
        self.textColor = color
        self.numberOfLines = lines
    }
}

enum FontType {
    case bold, semiBold, regular, medium, heavy

    public var font: UIFont {
        return getFontWithSize(15)
    }

    /** Define in-app font by setting different parameters:
     - set weight (bold, semibold or regular)
     - if iOS >= 13.0, set to rounded font because it looks better !
     */
    public func getFontWithSize(_ size: CGFloat) -> UIFont {
        /// get adjusted font size in case the user use custom font size in phone settings

        /// set custom weight
        var weight = UIFont.Weight.regular
        switch self {
        case .heavy:
            weight = .heavy
        case .bold:
            weight = .bold
        case .semiBold:
            weight = .semibold
        case .medium:
            weight = .medium
        default:
            weight = .regular
        }

        /// create font with adjusted font size and custom weight
        let font = UIFont.systemFont(ofSize: size, weight: weight)

        /// if available, use rounded font
        if #available(iOS 13.0, *), let fontDescriptor = font.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: fontDescriptor, size: size)
        }
        return font
    }
}
