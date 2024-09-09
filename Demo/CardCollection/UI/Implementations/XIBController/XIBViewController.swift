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
        collectionView.dequeueReusableCell(CardCollectionViewCell.self, for: indexPath) { cell in
            cell.configure(cardModel: CardModel.cards[indexPath.item])
        }
    }

}
