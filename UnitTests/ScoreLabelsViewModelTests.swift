//
//  ScoreLabelsViewModelTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation

import XCTest
import Combine
@testable import YourScore

final class ScoreLabelsViewModelTests: XCTestCase {

    func testPropertiesRepresentExpectedValues() {

        let model = Model(
            score: 567,
            minScore: 0,
            maxScore: 700
        )

        let viewModel = ScoreLabelsViewModel(model: model)

        XCTAssertEqual(viewModel.score, 567)
        XCTAssertEqual(viewModel.maxScore, 700)
        XCTAssertEqual(viewModel.maxScoreLabelText, "out of 700")
    }
}
