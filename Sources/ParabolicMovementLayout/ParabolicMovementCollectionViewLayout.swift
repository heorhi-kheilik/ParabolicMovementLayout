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

    // MARK: Internal properties

    @IBInspectable private(set) public var startPosition: CGFloat = .zero
    @IBInspectable private(set) public var amountOfCardsFromStartToTop: CGFloat = .zero
    @IBInspectable private(set) public var cardStandardSize: CGSize = .zero

    @IBInspectable public var disappearanceTopCardOffset: CGFloat = .zero

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

    private var accelerationCoefficient: CGFloat = .zero
    private var fullPathContentOffset: CGFloat = .zero
    private var contentOffsetBetweenCards: CGFloat = .zero

    // MARK: Initialization

    public init(startPosition: CGFloat, amountOfCardsFromStartToTop: CGFloat, cardStandardSize: CGSize) {
        self.startPosition = startPosition
        self.amountOfCardsFromStartToTop = amountOfCardsFromStartToTop
        self.cardStandardSize = cardStandardSize

        accelerationCoefficient = 1 / (4 * startPosition)
        fullPathContentOffset = 2 * startPosition
        contentOffsetBetweenCards = fullPathContentOffset / amountOfCardsFromStartToTop

        super.init()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Internal methods

    public override func awakeFromNib() {
        super.awakeFromNib()
        accelerationCoefficient = 1 / (4 * startPosition)
        fullPathContentOffset = 2 * startPosition
        contentOffsetBetweenCards = fullPathContentOffset / amountOfCardsFromStartToTop
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
        let mainCardRealPosition = calculatePosition(normalizedContentOffset: mainCardNormalizedContentOffset)

        var cardPositionModels: [CardPositionModel] = []
        if mainCardIndex < itemCount {
            cardPositionModels.append((
                index: mainCardIndex,
                normalizedContentOffset: mainCardNormalizedContentOffset,
                realPosition: mainCardRealPosition
            ))
        }

        let contentOffsetAtOverlapping = fullPathContentOffset + contentOffsetBetweenCards / 2
        let realPositionOfOverlapping = calculatePosition(normalizedContentOffset: contentOffsetAtOverlapping)
        let realPositionOfDisappearance = realPositionOfOverlapping + disappearanceTopCardOffset
        let (_, contentOffsetOfDisappearance) = contentOffsetForRealPosition(realPositionOfDisappearance)

        var currentCardIndex = mainCardIndex - 1
        var currentCardNormalizedContentOffset = mainCardNormalizedContentOffset + contentOffsetBetweenCards
        while currentCardIndex >= 0 && currentCardNormalizedContentOffset < contentOffsetOfDisappearance {
            let currentCardRealPosition = calculatePosition(normalizedContentOffset: currentCardNormalizedContentOffset)
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

        let (contentOffsetAtBottomAppearance, _) = contentOffsetForRealPosition(collectionView.bounds.height)
        currentCardIndex = mainCardIndex + 1
        currentCardNormalizedContentOffset = mainCardNormalizedContentOffset - contentOffsetBetweenCards
        while currentCardIndex < itemCount && currentCardNormalizedContentOffset > contentOffsetAtBottomAppearance {
            let currentCardRealPosition = calculatePosition(normalizedContentOffset: currentCardNormalizedContentOffset)
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

    private func calculatePosition(normalizedContentOffset x: CGFloat) -> CGFloat {
        return
            accelerationCoefficient * pow(x, 2)  // x^2
            - x                                  // x^1
            + startPosition                      // x^0
    }

    private func calculateScale(normalizedContentOffset: CGFloat) -> CGFloat {
        1 - normalizedContentOffset / 2900
    }

    /// This function solves the equation that defines movement.
    ///
    /// The equation is:
    /// ```
    /// AC * x^2 + SV * x + SP = RP, where
    ///     AC is Acceleration Coeffecient (to be consice, acceleration coefficient is acceleration divided by 2,
    ///         but real acceleration value is not important here),
    ///     SV is Start Velocity (equals to -1, since real position decreases while contentOffset increases),
    ///     IO is Index Offset (calculated using cardIndex)
    ///     SP is Start Position,
    ///     RP is Real Position, or y.
    /// ```
    ///
    /// Applying some modifications:
    /// ```
    /// AC * x^2 - x + (SP - RP) = 0
    /// ```
    ///
    /// Now we can solve equation with discriminant.
    /// ```
    /// Let DS = DiScriminant, then
    /// DS = b^2 - 4 * a * c
    ///
    /// a = AC
    /// b = -1
    /// c = SP - RP
    ///
    /// DS = 1 - 4 * AC * (SP - RP)
    /// ```
    ///
    private func contentOffsetForRealPosition(_ realPosition: CGFloat) -> (CGFloat, CGFloat) {
        let discriminant = 1 - 4 * accelerationCoefficient * (startPosition - realPosition)
        guard discriminant >= 0 else {
            assertionFailure("Equation has no roots for provided realPosition (\(realPosition))!")
            return (.zero, .zero)
        }
        let discriminantSqrt = discriminant.squareRoot()

        let x1 = (1 - discriminantSqrt) / (2 * accelerationCoefficient)
        let x2 = (1 + discriminantSqrt) / (2 * accelerationCoefficient)

        return (x1, x2)
    }

}
