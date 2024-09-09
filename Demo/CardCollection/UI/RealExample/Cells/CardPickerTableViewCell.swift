//
//  CardPickerTableViewCell.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 21.08.24.
//

import ReusableKit
import UIKit

final class CardPickerTableViewCell: UITableViewCell, NibInstantiatable {

    // MARK: Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 4
    }

    // MARK: IBOutlets

    @IBOutlet private weak var cardView: UIView!

    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var cardNameLabel: UILabel!

    // MARK: Internal properties

    private(set) var cardModel: CardModel?

    // MARK: Internal methods

    func configure(cardModel: CardModel) {
        cardNumberLabel.text = cardModel.number
        cardNameLabel.text = cardModel.name

        cardView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        setGradient(ofType: cardModel.gradientType)

        self.cardModel = cardModel
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        if let gradientType = cardModel?.gradientType {
            setGradient(ofType: gradientType)
        }
    }

    // MARK: Private methods

    private func setGradient(ofType type: GradientProvider.GradientType) {
        cardView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        let gradientLayer = GradientProvider.gradient(ofType: type)
        gradientLayer.frame = cardView.bounds
        gradientLayer.cornerRadius = Constants.cornerRadius
        cardView.layer.insertSublayer(gradientLayer, at: 0)
    }

}
