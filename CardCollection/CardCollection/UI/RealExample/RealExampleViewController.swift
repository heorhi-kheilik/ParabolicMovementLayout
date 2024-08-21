//
//  RealExampleViewController.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 21.08.24.
//

import UIKit

final class RealExampleViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!

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
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(CardPickerTableViewCell.self, for: indexPath) { cell in
                cell.configure(cardNumber: "4422 **** **** 9999", cardName: "Default")
            }

        case 1:
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
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
