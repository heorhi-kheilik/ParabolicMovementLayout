//
//  RootViewController.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 4.08.24.
//

import SwiftUI
import UIKit

final class RootViewController: UIHostingController<RootView> {

    init() {
        super.init(rootView: RootView())
        rootView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - RootViewDelegate

extension RootViewController: @preconcurrency RootViewDelegate {

    func programmaticImplementationTouchUpInside() {
        print("progammatic")
    }

    func xibImplementationTouchUpInside() {
        let controller = XIBViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true)
    }

}
