//
//  CardPickerTableViewCell.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 21.08.24.
//

import UIKit

final class CardPickerTableViewCell: UITableViewCell {

    // MARK: Constants

    private enum Colors {
        static let pinkColor = UIColor(named: "pinkGradient")!
        static let blueColor = UIColor(named: "blueGradient")!
    }

    // MARK: IBOutlets

    @IBOutlet private weak var cardView: UIView!

    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var cardNameLabel: UILabel!

    // MARK: Internal methods

    func configure(cardNumber: String, cardName: String) {
        cardNumberLabel.text = cardNumber
        cardNameLabel.text = cardName
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayer = createGradient(in: cardView.bounds)
        cardView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        cardView.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: Private methods

    private func createGradient(in frame: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            Colors.pinkColor.cgColor,
            Colors.blueColor.cgColor
        ]
        layer.frame = frame
        layer.cornerRadius = 4
        layer.startPoint = .init(x: 0, y: 0)
        layer.endPoint = .init(x: 1, y: 1)
        return layer
    }

}
