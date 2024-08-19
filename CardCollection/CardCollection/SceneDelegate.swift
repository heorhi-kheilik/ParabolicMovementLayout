//
//  SceneDelegate.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 18.07.24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: Internal properties

    var window: UIWindow?

    // MARK: Internal methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: RootViewController())
        window.makeKeyAndVisible()
        self.window = window
    }

}
