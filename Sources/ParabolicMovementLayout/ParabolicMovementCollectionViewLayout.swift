//
//  ParabolicMovementCollectionViewLayout.swift
//  ParabolicMovementLayout
//
//  Created by Heorhi Heilik on 31.07.24.
//

import UIKit

public final class ParabolicMovementCollectionViewLayout: ContentOffsetCollectionViewLayout {

    // MARK: Constants

    private typealias ItemPositionModel = (index: Int, normalizedContentOffset: CGFloat, realPosition: CGFloat)

    // MARK: Public properties

    @IBInspectable private(set) public var startVelocity: CGFloat = .zero
    @IBInspectable private(set) public var startPosition: CGFloat = .zero

    @IBInspectable private(set) public var amountOfItemsFromStartToTop: CGFloat = .zero
    @IBInspectable private(set) public var disappearanceTopItemOffset: CGFloat = .zero

    @IBInspectable private(set) public var itemStandardSize: CGSize = .zero
    @IBInspectable private(set) public var scaleAtVertex: CGFloat = .zero

    public override var collectionViewContentSize: CGSize {
        guard
            let collectionView,
            let itemCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0)
        else {
            return .zero
        }
        return CGSize(
            width: collectionView.bounds.width,
            height: collectionView.bounds.height + CGFloat(itemCount - 1) * contentOffsetBetweenItems
        )
    }

    // MARK: Private properties

    private var movementFunction: MovementFunction!
    private var scaleFunction: ScaleFunction!

    private var contentOffsetBetweenItems: CGFloat = .zero
    private var contentOffsetOfTopDisappearance: CGFloat = .zero
    private var contentOffsetOfBottomDisappearance: CGFloat = .zero

    // MARK: Initialization

    public init(
        startVelocity: CGFloat,
        startPosition: CGFloat,
        amountOfItemsFromStartToTop: CGFloat,
        disappearanceTopItemOffset: CGFloat,
        itemStandardSize: CGSize,
        scaleAtVertex: CGFloat
    ) {
        movementFunction = MovementFunction(
            startVelocity: startVelocity,
            startPosition: startPosition
        )
        scaleFunction = ScaleFunction(
            contentOffsetOfParabolaVertex: movementFunction.contentOffsetOfParabolaVertex,
            scaleAtVertex: scaleAtVertex
        )

        self.amountOfItemsFromStartToTop = amountOfItemsFromStartToTop
        self.disappearanceTopItemOffset = disappearanceTopItemOffset
        self.itemStandardSize = itemStandardSize

        super.init()

        contentOffsetBetweenItems = calculateContentOffsetBetweenItems()
        contentOffsetOfTopDisappearance = calculateContentOffsetOfTopDisappearance()
        contentOffsetOfBottomDisappearance = calculateContentOffsetOfBottomDisappearance()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Internal methods

    public override func awakeFromNib() {
        super.awakeFromNib()

        movementFunction = MovementFunction(
            startVelocity: startVelocity,
            startPosition: startPosition
        )
        scaleFunction = ScaleFunction(
            contentOffsetOfParabolaVertex: movementFunction.contentOffsetOfParabolaVertex,
            scaleAtVertex: scaleAtVertex
        )

        contentOffsetBetweenItems = calculateContentOffsetBetweenItems()
        contentOffsetOfTopDisappearance = calculateContentOffsetOfTopDisappearance()
        contentOffsetOfBottomDisappearance = calculateContentOffsetOfBottomDisappearance()
    }

    public override func layoutAttributesForVisibleItems(contentOffset: CGPoint) -> [UICollectionViewLayoutAttributes] {
        guard
            let collectionView,
            let itemCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0)
        else {
            return []
        }

        let mainItemIndex = Int(max(0, floor(contentOffset.y / contentOffsetBetweenItems)))
        let mainItemNormalizedContentOffset = normalizeContentOffset(contentOffset.y, forItemIndex: mainItemIndex)
        let mainItemRealPosition = movementFunction.position(for: mainItemNormalizedContentOffset)

        var itemPositionModels: [ItemPositionModel] = []
        if mainItemIndex < itemCount {
            itemPositionModels.append((
                index: mainItemIndex,
                normalizedContentOffset: mainItemNormalizedContentOffset,
                realPosition: mainItemRealPosition
            ))
        }

        var currentItemIndex = mainItemIndex - 1
        var currentItemNormalizedContentOffset = mainItemNormalizedContentOffset + contentOffsetBetweenItems
        while currentItemIndex >= 0 && currentItemNormalizedContentOffset < contentOffsetOfTopDisappearance {
            let currentItemRealPosition = movementFunction.position(for: currentItemNormalizedContentOffset)
            if currentItemIndex < itemCount {
                itemPositionModels.append((
                    index: currentItemIndex,
                    normalizedContentOffset: currentItemNormalizedContentOffset,
                    realPosition: currentItemRealPosition
                ))
            }
            currentItemIndex -= 1
            currentItemNormalizedContentOffset += contentOffsetBetweenItems
        }

        currentItemIndex = mainItemIndex + 1
        currentItemNormalizedContentOffset = mainItemNormalizedContentOffset - contentOffsetBetweenItems
        while currentItemIndex < itemCount && currentItemNormalizedContentOffset > contentOffsetOfBottomDisappearance {
            let currentItemRealPosition = movementFunction.position(for: currentItemNormalizedContentOffset)
            itemPositionModels.append((
                index: currentItemIndex,
                normalizedContentOffset: currentItemNormalizedContentOffset,
                realPosition: currentItemRealPosition
            ))
            currentItemIndex += 1
            currentItemNormalizedContentOffset -= contentOffsetBetweenItems
        }

        var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []
        for itemPositionModel in itemPositionModels {
            let scale = scaleFunction.scale(for: itemPositionModel.normalizedContentOffset)

            let itemLayoutAttributes = UICollectionViewLayoutAttributes(
                forCellWith: IndexPath(
                    item: itemPositionModel.index,
                    section: 0
                )
            )
            itemLayoutAttributes.size = itemStandardSize
            itemLayoutAttributes.center = CGPoint(
                x: collectionView.bounds.width / 2,
                y: itemPositionModel.realPosition + itemStandardSize.height / 2 * scale + contentOffset.y
            )

            itemLayoutAttributes.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)

            itemLayoutAttributes.zIndex = itemPositionModel.index

            layoutAttributesArray.append(itemLayoutAttributes)
        }

        return layoutAttributesArray
    }

    // MARK: Private methods

    private func normalizeContentOffset(_ contentOffset: CGFloat, forItemIndex index: Int) -> CGFloat {
        contentOffset - CGFloat(index) * contentOffsetBetweenItems
    }

    private func calculateContentOffsetBetweenItems() -> CGFloat {
        movementFunction.contentOffsetOfParabolaVertex / amountOfItemsFromStartToTop
    }

    private func calculateContentOffsetOfTopDisappearance() -> CGFloat {
        let contentOffsetAtOverlapping = movementFunction.contentOffsetOfParabolaVertex + contentOffsetBetweenItems / 2
        let positionOfOverlapping = movementFunction.position(for: contentOffsetAtOverlapping)
        let positionOfDisappearance = positionOfOverlapping + disappearanceTopItemOffset
        let (_, contentOffsetOfDisappearance) = movementFunction.contentOffsets(for: positionOfDisappearance)
        return contentOffsetOfDisappearance
    }

    private func calculateContentOffsetOfBottomDisappearance() -> CGFloat {
        guard let collectionViewHeight = collectionView?.bounds.height else { return .zero }
        let (contentOffsetAtBottomAppearance, _) = movementFunction.contentOffsets(for: collectionViewHeight)
        return contentOffsetAtBottomAppearance
    }

}
