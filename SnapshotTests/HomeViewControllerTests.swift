//
//  HomeViewControllerTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import SnapshotTesting

class HomeViewControllerTests: XCTestCase {

    func testShowsLoading() {

        let scoreViewModel = ScoreViewViewModel(animated: false)
        let viewModel = HomeViewModel(service: .loading, scoreViewModel: scoreViewModel)
        let homeViewController = HomeViewController(viewModel: viewModel)
        homeViewController.viewDidAppear(false)

        assertSnapshot(
            matching: homeViewController,
            as: .image
        )
    }

    func testShowsFailed() {

        let scoreViewModel = ScoreViewViewModel(animated: false)
        let viewModel = HomeViewModel(service: .failing, scoreViewModel: scoreViewModel)
        let homeViewController = HomeViewController(viewModel: viewModel)
        homeViewController.viewDidAppear(false)

        assertSnapshot(
            matching: homeViewController,
            as: .image
        )
    }

    func testShowsLoaded() {

        let scoreViewModel = ScoreViewViewModel(animated: false)
        let viewModel = HomeViewModel(service: .stub, scoreViewModel: scoreViewModel)
        let homeViewController = HomeViewController(viewModel: viewModel)
        homeViewController.viewDidAppear(false)

        assertSnapshot(
            matching: homeViewController,
            as: .image
        )
    }
}
