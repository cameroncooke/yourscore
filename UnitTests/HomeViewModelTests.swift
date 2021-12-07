//
//  HomeViewModelTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
@testable import YourScore

class HomeViewModelTests: XCTestCase {

    func testDependenciesAreSetOnInitialisation() {

        let service: Service = .stub
        let scoreViewModel = ScoreViewViewModel(animated: false)

        let homeViewModel = HomeViewModel(
            service: service,
            scoreViewModel: scoreViewModel
        )

        XCTAssertIdentical(homeViewModel.service, service)
        XCTAssertIdentical(homeViewModel.scoreViewModel, scoreViewModel)
    }

    func testFetchScoreCallsServiceFetch() {

        var didCallFetch: Bool?

        let homeViewModel = HomeViewModel(
            service: Service(
                fetch: { _ in
                    didCallFetch = true
                }
            ),
            scoreViewModel: ScoreViewViewModel(animated: false)
        )
        homeViewModel.fetchScore()

        XCTAssertTrue(try XCTUnwrap(didCallFetch))
    }

    func testServiceFetchIsCalledOnRetry() {

        let scoreViewModel = ScoreViewViewModel(animated: false)

        var didCallFetch: Bool?

        let homeViewModel = HomeViewModel(
            service: Service(
                fetch: { _ in
                    didCallFetch = true
                }
            ),
            scoreViewModel: scoreViewModel
        )

        scoreViewModel.retryAction()

        XCTAssertTrue(try XCTUnwrap(didCallFetch))

        // Added to suppress warning that homeViewModel is not used
        XCTAssertNotNil(homeViewModel)
    }

    func testFetchScoreWithSuccessUpdatesScoreViewModel() {

        let scoreViewModel = ScoreViewViewModel(animated: false)

        let homeViewModel = HomeViewModel(
            service: .stub,
            scoreViewModel: scoreViewModel
        )

        homeViewModel.fetchScore()

        let labelsViewModel = ScoreLabelsViewModel(
            model: Model(
                score: 578,
                minScore: 0,
                maxScore: 700
            )
        )
        XCTAssertEqual(scoreViewModel.state, .loaded(model: labelsViewModel))
    }

    func testFetchScoreWithFailureUpdatesScoreViewModel() {

        let scoreViewModel = ScoreViewViewModel(animated: false)

        let homeViewModel = HomeViewModel(
            service: .failing,
            scoreViewModel: scoreViewModel
        )

        homeViewModel.fetchScore()

        XCTAssertEqual(scoreViewModel.state, .failed)
    }
}
