//
//  SceneDelegate.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var homeCoordinator: HomeCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()

        homeCoordinator = HomeCoordinator(
            navigator: .live(navigationController: navigationController)
        )
        homeCoordinator?.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window

        window.makeKeyAndVisible()
    }
}

