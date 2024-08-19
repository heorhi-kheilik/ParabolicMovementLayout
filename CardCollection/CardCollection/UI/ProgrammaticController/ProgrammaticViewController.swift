//
//  ProgrammaticViewController.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 5.08.24.
//

import ParabolicMovementLayout
import UIKit

final class ProgrammaticViewController: UIViewController {

    // MARK: UI

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: ParabolicMovementCollectionViewLayout(
                startVelocity: -1,
                startPosition: 290,
                spacingDivisionCoefficient: 3,
                disappearanceTopItemOffset: 20,
                itemStandardSize: CGSize(width: 329, height: 207),
                scaleAtVertex: 0.8,
                fallbackCollectionViewHeight: 549
            )
        )
        collectionView.isOpaque = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()

    private let doneButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.titleTextAttributesTransformer = .init {
            var attributes = $0
            attributes.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            return attributes
        }
        configuration.title = "Done"
        return UIButton(configuration: configuration)
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose card"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureButton()
        configureCollectionView()

        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        view.addSubview(doneButton)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 549),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -24),

            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            doneButton.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor, constant: -2)
        ])
    }

    // MARK: Private methods

    private func configureView() {
        view.backgroundColor = UIColor(named: "shadowBackground")
        view.isOpaque = false
    }

    private func configureButton() {
        doneButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }

    private func configureCollectionView() {
        collectionView.register(CardCollectionViewCell.self)
        collectionView.dataSource = self
    }

}

// MARK: - UICollectionViewDataSource

extension ProgrammaticViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 20 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CardCollectionViewCell.identifier,
                for: indexPath
            ) as? CardCollectionViewCell
        else {
            assertionFailure("Failed to dequeue CardCollectionViewCell.")
            return UICollectionViewCell()
        }

        var last4Digits = String(indexPath.row)
        let zeroesToPrependCount = max(0, 4 - last4Digits.count)
        last4Digits = String(repeating: "0", count: zeroesToPrependCount) + last4Digits
        cell.configure(cardNumber: "4422 **** **** \(last4Digits)", cardName: "Default")

        return cell
    }

}
