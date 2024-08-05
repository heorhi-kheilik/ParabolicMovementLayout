//
//  XIBViewController.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 18.07.24.
//

import UIKit

final class XIBViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    // MARK: Private methods

    private func configureCollectionView() {
        collectionView.register(CardCollectionViewCell.self)
        collectionView.dataSource = self
    }

    // MARK: IBActions

    @IBAction
    private func doneButtonTouchUpInside() {
        dismiss(animated: true)
    }

}

// MARK: - UICollectionViewDataSource

extension XIBViewController: UICollectionViewDataSource {

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
