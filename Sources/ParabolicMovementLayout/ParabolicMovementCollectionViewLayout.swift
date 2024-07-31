//
//  ParabolicMovementCollectionViewLayout.swift
//  ParabolicMovementLayout
//
//  Created by Heorhi Heilik on 31.07.24.
//

import UIKit

public final class ParabolicMovementCollectionViewLayout: ContentOffsetCollectionViewLayout {

    // MARK: Constants

    private typealias CardPositionModel = (index: Int, normalizedContentOffset: CGFloat, realPosition: CGFloat)

    // MARK: Public properties

    @IBInspectable private(set) public var startVelocity: CGFloat = .zero
    @IBInspectable private(set) public var startPosition: CGFloat = .zero

    @IBInspectable private(set) public var amountOfCardsFromStartToTop: CGFloat = .zero
    @IBInspectable private(set) public var disappearanceTopCardOffset: CGFloat = .zero

    @IBInspectable private(set) public var cardStandardSize: CGSize = .zero

    public override var collectionViewContentSize: CGSize {
        guard
            let collectionView,
            let itemCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0)
        else {
            return .zero
        }
        return CGSize(
            width: collectionView.bounds.width,
            height: collectionView.bounds.height + CGFloat(itemCount - 1) * contentOffsetBetweenCards
        )
    }

    // MARK: Private properties

    private var movementFunction: MovementFunction!

    private var contentOffsetBetweenCards: CGFloat = .zero
    private var contentOffsetOfTopDisappearance: CGFloat = .zero
    private var contentOffsetOfBottomDisappearance: CGFloat = .zero

    // MARK: Initialization

    public init(
        startVelocity: CGFloat,
        startPosition: CGFloat,
        amountOfCardsFromStartToTop: CGFloat,
        disappearanceTopCardOffset: CGFloat,
        cardStandardSize: CGSize
    ) {
        self.movementFunction = MovementFunction(startVelocity: startVelocity, startPosition: startPosition)
        self.amountOfCardsFromStartToTop = amountOfCardsFromStartToTop
        self.disappearanceTopCardOffset = disappearanceTopCardOffset
        self.cardStandardSize = cardStandardSize

        super.init()

        contentOffsetBetweenCards = calculateContentOffsetBetweenCards()
        contentOffsetOfTopDisappearance = calculateContentOffsetOfTopDisappearance()
        contentOffsetOfBottomDisappearance = calculateContentOffsetOfBottomDisappearance()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Internal methods

    public override func awakeFromNib() {
        super.awakeFromNib()

        movementFunction = MovementFunction(startVelocity: startVelocity, startPosition: startPosition)

        contentOffsetBetweenCards = calculateContentOffsetBetweenCards()
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

        let mainCardIndex = Int(max(0, floor(contentOffset.y / contentOffsetBetweenCards)))
        let mainCardNormalizedContentOffset = normalizeContentOffset(contentOffset.y, forCardIndex: mainCardIndex)
        let mainCardRealPosition = movementFunction.position(for: mainCardNormalizedContentOffset)

        var cardPositionModels: [CardPositionModel] = []
        if mainCardIndex < itemCount {
            cardPositionModels.append((
                index: mainCardIndex,
                normalizedContentOffset: mainCardNormalizedContentOffset,
                realPosition: mainCardRealPosition
            ))
        }

        var currentCardIndex = mainCardIndex - 1
        var currentCardNormalizedContentOffset = mainCardNormalizedContentOffset + contentOffsetBetweenCards
        while currentCardIndex >= 0 && currentCardNormalizedContentOffset < contentOffsetOfTopDisappearance {
            let currentCardRealPosition = movementFunction.position(for: currentCardNormalizedContentOffset)
            if currentCardIndex < itemCount {
                cardPositionModels.append((
                    index: currentCardIndex,
                    normalizedContentOffset: currentCardNormalizedContentOffset,
                    realPosition: currentCardRealPosition
                ))
            }
            currentCardIndex -= 1
            currentCardNormalizedContentOffset += contentOffsetBetweenCards
        }

        currentCardIndex = mainCardIndex + 1
        currentCardNormalizedContentOffset = mainCardNormalizedContentOffset - contentOffsetBetweenCards
        while currentCardIndex < itemCount && currentCardNormalizedContentOffset > contentOffsetOfBottomDisappearance {
            let currentCardRealPosition = movementFunction.position(for: currentCardNormalizedContentOffset)
            cardPositionModels.append((
                index: currentCardIndex,
                normalizedContentOffset: currentCardNormalizedContentOffset,
                realPosition: currentCardRealPosition
            ))
            currentCardIndex += 1
            currentCardNormalizedContentOffset -= contentOffsetBetweenCards
        }

        var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []
        for cardPositionModel in cardPositionModels {
            let scale = calculateScale(normalizedContentOffset: cardPositionModel.normalizedContentOffset)

            let cardLayoutAttributes = UICollectionViewLayoutAttributes(
                forCellWith: IndexPath(
                    item: cardPositionModel.index,
                    section: 0
                )
            )
            cardLayoutAttributes.size = cardStandardSize
            cardLayoutAttributes.center = CGPoint(
                x: collectionView.bounds.width / 2,
                y: cardPositionModel.realPosition + cardStandardSize.height / 2 * scale + contentOffset.y
            )

            cardLayoutAttributes.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)

            cardLayoutAttributes.zIndex = cardPositionModel.index

            layoutAttributesArray.append(cardLayoutAttributes)
        }

        return layoutAttributesArray
    }

    // MARK: Private methods

    private func normalizeContentOffset(_ contentOffset: CGFloat, forCardIndex index: Int) -> CGFloat {
        contentOffset - CGFloat(index) * contentOffsetBetweenCards
    }

    private func calculateScale(normalizedContentOffset: CGFloat) -> CGFloat {
        1 - normalizedContentOffset / 2900
    }

    private func calculateContentOffsetBetweenCards() -> CGFloat {
        movementFunction.contentOffsetOfParabolaVertex / amountOfCardsFromStartToTop
    }

    private func calculateContentOffsetOfTopDisappearance() -> CGFloat {
        let contentOffsetAtOverlapping = movementFunction.contentOffsetOfParabolaVertex + contentOffsetBetweenCards / 2
        let positionOfOverlapping = movementFunction.position(for: contentOffsetAtOverlapping)
        let positionOfDisappearance = positionOfOverlapping + disappearanceTopCardOffset
        let (_, contentOffsetOfDisappearance) = movementFunction.contentOffsets(for: positionOfDisappearance)
        return contentOffsetOfDisappearance
    }

    private func calculateContentOffsetOfBottomDisappearance() -> CGFloat {
        guard let collectionViewHeight = collectionView?.bounds.height else { return .zero }
        let (contentOffsetAtBottomAppearance, _) = movementFunction.contentOffsets(for: collectionViewHeight)
        return contentOffsetAtBottomAppearance
    }

}
