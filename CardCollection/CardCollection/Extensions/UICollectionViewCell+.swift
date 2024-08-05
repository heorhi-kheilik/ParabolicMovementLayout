//
//  UICollectionViewCell+.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 23.07.24.
//

import UIKit

extension UICollectionViewCell {

    static var identifier: String {
        String(describing: self)
    }

    static var nib: UINib? {
        guard
            let url = Bundle.main.url(forResource: String(describing: self), withExtension: "nib"),
            let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return UINib(data: data, bundle: nil)
    }

}
