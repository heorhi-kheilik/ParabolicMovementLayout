//
//  UIView+IBInspectable.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 24.07.24.
//

import UIKit

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable
    var shadowOffset: CGPoint {
        get {
            CGPoint(
                x: layer.shadowOffset.width,
                y: layer.shadowOffset.height
            )
        }
        set { layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y) }
    }

    @IBInspectable
    var shadowColor: UIColor {
        get {
            guard let shadowColor = layer.shadowColor else { return .black }
            return UIColor(cgColor: shadowColor)
        }
        set { layer.shadowColor = newValue.cgColor }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

}
