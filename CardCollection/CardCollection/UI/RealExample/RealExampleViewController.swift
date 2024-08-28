//
//  RealExampleViewController.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 21.08.24.
//

import UIKit

final class RealExampleViewController: UIViewController {

    // MARK: Constants

    private enum CardType {
        case source
        case target

        var indexPath: IndexPath {
            switch self {
            case .source: IndexPath(item: 0, section: 0)
            case .target: IndexPath(item: 1, section: 0)
            }
        }
    }

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: Private properties

    private var sourceIndexPath: IndexPath = .init(item: 0, section: 0)
    private var targetIndexPath: IndexPath = .init(item: 1, section: 0)

    private var currentlySelectedCell: CardType?

    // MARK: Internal methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Transaction"
    }

    // MARK: Private methods

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardPickerTableViewCell.self)
        tableView.register(ButtonTableViewCell.self)
    }

    private func presentCardPicker() {
        let controller = CardPickerViewController()
        controller.delegate = self
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

}

// MARK: - UITableViewDataSource

extension RealExampleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:  2
        case 1:  1
        default: 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return tableView.dequeueReusableCell(CardPickerTableViewCell.self, for: indexPath) { cell in
                let last4Digits = IndexPathFormatter.last4Digits(for: sourceIndexPath)
                cell.configure(cardNumber: "4422 **** **** \(last4Digits)", cardName: "Default")
            }

        case (0, 1):
            return tableView.dequeueReusableCell(CardPickerTableViewCell.self, for: indexPath) { cell in
                let last4Digits = IndexPathFormatter.last4Digits(for: targetIndexPath)
                cell.configure(cardNumber: "4422 **** **** \(last4Digits)", cardName: "Default")
            }

        case (1, 0):
            return tableView.dequeueReusableCell(ButtonTableViewCell.self, for: indexPath) { cell in
                cell.configure(title: "Proceed")
            }

        default:
            assertionFailure("Invalid indexPath: \(indexPath)")
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else { return nil }
        return "Select Source and Target"
    }

}

// MARK: - UITableViewDelegate

extension RealExampleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        guard indexPath.section == 0 else {
            return
        }

        switch indexPath.row {
        case 0:
            currentlySelectedCell = .source
        case 1:
            currentlySelectedCell = .target
        default:
            break
        }

        presentCardPicker()
    }

}

// MARK: - CardPickerViewControllerDelegate

extension RealExampleViewController: CardPickerViewControllerDelegate {

    func didSelectCard(at indexPath: IndexPath) {
        switch currentlySelectedCell {
        case .source:
            sourceIndexPath = indexPath
            tableView.performBatchUpdates {
                tableView.reloadRows(at: [CardType.source.indexPath], with: .automatic)
            }

        case .target:
            targetIndexPath = indexPath
            tableView.performBatchUpdates {
                tableView.reloadRows(at: [CardType.target.indexPath], with: .automatic)
            }

        case nil:
            break
        }

        currentlySelectedCell = nil
    }

}
