//
//  CardPickerViewController.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 21.08.24.
//

import UIKit

@MainActor
protocol CardPickerViewControllerDelegate: AnyObject {
    func didSelectCard(at indexPath: IndexPath)
}

final class CardPickerViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: Internal properties

    weak var delegate: (any CardPickerViewControllerDelegate)?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    // MARK: Private methods

    private func configureCollectionView() {
        collectionView.register(CardCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: IBActions

    @IBAction
    private func cancelButtonTouchUpInside() {
        dismiss(animated: true)
    }

}

// MARK: - UICollectionViewDataSource

extension CardPickerViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 20 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(CardCollectionViewCell.self, for: indexPath) { cell in
            cell.configure(cardModel: CardModel.cards[indexPath.item])
        }
    }

}

// MARK: - UICollectionViewDelegate

extension CardPickerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCard(at: indexPath)
        dismiss(animated: true)
    }

}
