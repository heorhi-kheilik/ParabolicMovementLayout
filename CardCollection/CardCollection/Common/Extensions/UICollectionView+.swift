//
//  UICollectionView+.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 23.07.24.
//

import UIKit

extension UICollectionView {

    func register<Cell: UICollectionViewCell>(_ cellType: Cell.Type) {
        guard let nib = cellType.nib else {
            register(cellType, forCellWithReuseIdentifier: cellType.identifier)
            return
        }
        register(nib, forCellWithReuseIdentifier: cellType.identifier)
    }

}
