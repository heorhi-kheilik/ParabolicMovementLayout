//
//  RootViewController.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 4.08.24.
//

import SwiftUI
import UIKit

final class RootViewController: UIHostingController<RootView> {

    // MARK: Initialization

    init() {
        super.init(rootView: RootView())
        rootView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Choose Implementation"
    }

}

// MARK: - RootViewDelegate

extension RootViewController: RootViewDelegate {

    func realExampleTouchUpInside() {
        navigationController?.pushViewController(RealExampleViewController(), animated: true)
    }

    func programmaticImplementationTouchUpInside() {
        let controller = ProgrammaticViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true)
    }

    func xibImplementationTouchUpInside() {
        let controller = XIBViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true)
    }

}
