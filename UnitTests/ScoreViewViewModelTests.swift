//
//  ScoreViewViewModelTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import Combine
@testable import YourScore

final class ScoreViewViewModelTests: XCTestCase {

    func testAnimatedPropertyDefaultsToTrue() {
        let viewModel = ScoreViewViewModel()
        XCTAssertTrue(viewModel.animated)
    }

    func testSettingAnimatedToFalseOnInitializerUpdatesAnimatedProperty() {
        let viewModel = ScoreViewViewModel(animated: false)
        XCTAssertFalse(viewModel.animated)
    }

    func testLoadedUpdatesStateSubject() {

        let viewModel = ScoreViewViewModel()

        var state: ScoreViewViewModel.State?

        let cancellable = viewModel.statePublisher
            .sink {
                state = $0
            }

        let model = Model(
            score: 567,
            minScore: 0,
            maxScore: 700
        )

        viewModel.loaded(model: model)

        let expectedModel = ScoreLabelsViewModel(model: model)
        XCTAssertEqual(
            try XCTUnwrap(state),
            .loaded(model: expectedModel)
        )

        cancellable.cancel()
    }

    func testFailedUpdatesStateSubject() {

        let viewModel = ScoreViewViewModel()

        var state: ScoreViewViewModel.State?

        let cancellable = viewModel.statePublisher
            .sink {
                state = $0
            }

        viewModel.failed()

        XCTAssertEqual(
            try XCTUnwrap(state),
            .failed
        )

        cancellable.cancel()
    }

    func testRetryActionPublishesToRetrySubject() {

        let viewModel = ScoreViewViewModel()

        var didReceiveValue: Bool?

        let cancellable = viewModel.retryPublisher
            .sink {
                didReceiveValue = true
            }

        viewModel.retryAction()

        XCTAssertTrue(try XCTUnwrap(didReceiveValue))

        cancellable.cancel()
    }

    func testPercentageCompleteReturnsZeroWhenLoading() {

        let viewModel = ScoreViewViewModel()

        XCTAssertEqual(viewModel.percentageComplete, 0)
    }

    func testPercentageCompleteReturnsExpectedPercentageWhenLoaded() {

        let viewModel = ScoreViewViewModel()

        let model = Model(
            score: 567,
            minScore: 0,
            maxScore: 700
        )

        viewModel.loaded(model: model)

        XCTAssertEqual(viewModel.percentageComplete, 0.81)
    }

    func testPercentageCompleteReturnsOneWhenFailed() {

        let viewModel = ScoreViewViewModel()
        viewModel.failed()

        XCTAssertEqual(viewModel.percentageComplete, 1)
    }
}
