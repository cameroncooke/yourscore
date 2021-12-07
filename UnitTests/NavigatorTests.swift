//
//  NavigatorTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
@testable import YourScore

final class NavigatorTests: XCTestCase {

    func testNavigatorSetsViewControllers() {

        let navigationController = UINavigationController()
        let navigator: Navigator = .live(navigationController: navigationController)

        let testViewControllerA = UIViewController()
        let testViewControllerB = UIViewController()

        navigator.setViewControllers([testViewControllerA, testViewControllerB], false)

        XCTAssertEqual(
            navigationController.viewControllers,
            [testViewControllerA, testViewControllerB]
        )
    }

    func testNavigatorPushesViewController() {

        let navigationController = UINavigationController()
        let navigator: Navigator = .live(navigationController: navigationController)

        let testViewController = UIViewController()

        navigator.pushViewController(testViewController, false)

        XCTAssertEqual(
            navigationController.viewControllers,
            [testViewController]
        )
    }

    func testNavigatorPopsViewController() {

        let navigationController = UINavigationController()
        let navigator: Navigator = .live(navigationController: navigationController)

        let testViewControllerA = UIViewController()
        let testViewControllerB = UIViewController()

        navigator.setViewControllers([testViewControllerA, testViewControllerB], false)
        navigator.popViewController(false)

        XCTAssertEqual(
            navigationController.viewControllers,
            [testViewControllerA]
        )
    }
}
