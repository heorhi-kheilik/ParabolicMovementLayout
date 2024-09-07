//
//  CardCollectionViewCell.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 23.07.24.
//

import ReusableKit
import UIKit

final class CardCollectionViewCell: UICollectionViewCell, NibInstantiatable {

    // MARK: Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 8
    }

    // MARK: IBOutlets

    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var cardNameLabel: UILabel!

    // MARK: Internal properties

    private(set) var cardModel: CardModel?

    // MARK: Internal methods

    func configure(cardModel: CardModel) {
        cardNumberLabel.text = cardModel.number
        cardNameLabel.text = cardModel.name

        contentView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        setGradient(ofType: cardModel.gradientType)

        self.cardModel = cardModel
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        if let gradientType = cardModel?.gradientType {
            setGradient(ofType: gradientType)
        }
    }

    // MARK: Private methods

    private func setGradient(ofType type: GradientProvider.GradientType) {
        contentView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        let gradientLayer = GradientProvider.gradient(ofType: type)
        gradientLayer.frame = contentView.bounds
        gradientLayer.cornerRadius = Constants.cornerRadius
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

}
