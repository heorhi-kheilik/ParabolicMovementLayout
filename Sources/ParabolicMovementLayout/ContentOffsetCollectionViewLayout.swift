//
//  ContentOffsetCollectionViewLayout.swift
//  ParabolicMovementLayout
//
//  Created by Heorhi Heilik on 31.07.24.
//

import UIKit

open class ContentOffsetCollectionViewLayout: UICollectionViewLayout {

    // MARK: Public properties

    public var cachedAttributes: [UICollectionViewLayoutAttributes] = []

    // MARK: Private properties

    private var contentOffsetObservation: NSKeyValueObservation?

    // MARK: Open methods

    open override func prepare() {
        contentOffsetObservation = observe(\.collectionView?.contentOffset, options: [.new]) { [weak self] _, _ in
            MainActor.assumeIsolated {
                self?.invalidateLayout()
            }
        }
    }

    open override func invalidateLayout() {
        super.invalidateLayout()
        guard let contentOffset = collectionView?.contentOffset else { return }
        cachedAttributes = layoutAttributesForVisibleItems(contentOffset: contentOffset)
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cachedAttributes
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributes.first { $0.indexPath.row == indexPath.row }
    }

    open func layoutAttributesForVisibleItems(contentOffset: CGPoint) -> [UICollectionViewLayoutAttributes] {
        return []
    }

}
