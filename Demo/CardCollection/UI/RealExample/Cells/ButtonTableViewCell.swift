//
//  ButtonTableViewCell.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 21.08.24.
//

import UIKit

final class ButtonTableViewCell: UITableViewCell {

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Internal methods

    func configure(title: String) {
        var configuration = defaultContentConfiguration()
        configuration.text = title
        configuration.textProperties.color = .tintColor
        contentConfiguration = configuration
    }

}
