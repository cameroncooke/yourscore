//
//  HomeCoordinatorTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
@testable import YourScore

class HomeCoordinatorTests: XCTestCase {

    func testNavigatorIsSetOnInitialization() {

        let navigator = Navigator(
            setViewControllers: { _, _ in },
            pushViewController: { _, _ in },
            popViewController: { _ in }
        )

        let coordinator = HomeCoordinator(navigator: navigator)
        XCTAssertIdentical(coordinator.navigator, navigator)
    }

    func testStartCreatesHomeViewController() throws {

        var viewControllers: [UIViewController]?
        var animated: Bool?

        let navigator = Navigator(
            setViewControllers: {
                viewControllers = $0
                animated = $1
            },
            pushViewController: { _, _ in },
            popViewController: { _ in }
        )

        let coordinator = HomeCoordinator(navigator: navigator)
        coordinator.start()

        let actualViewControllers = try XCTUnwrap(viewControllers)

        XCTAssertEqual(actualViewControllers.count, 1)
        XCTAssertTrue(actualViewControllers.first is HomeViewController)
        XCTAssertFalse(try XCTUnwrap(animated))

    }
}
