//
//  ScoreViewTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import SnapshotTesting

class ScoreViewTests: XCTestCase {

    func testScoreViewLoading() {

        let scoreViewModel = ScoreViewViewModel(animated: false)

        let view = ScoreView(viewModel: scoreViewModel)
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)

        assertSnapshot(
            matching: view,
            as: .image
        )
    }

    func testScoreViewLoaded() {

        let model = Model(
            score: 567,
            minScore: 0,
            maxScore: 700
        )

        let scoreViewModel = ScoreViewViewModel(animated: false)
        scoreViewModel.loaded(model: model)

        let view = ScoreView(viewModel: scoreViewModel)
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)

        assertSnapshot(
            matching: view,
            as: .image
        )
    }

    func testScoreViewError() {

        let scoreViewModel = ScoreViewViewModel(animated: false)
        scoreViewModel.failed()

        let view = ScoreView(viewModel: scoreViewModel)
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)

        assertSnapshot(
            matching: view,
            as: .image
        )
    }
}
