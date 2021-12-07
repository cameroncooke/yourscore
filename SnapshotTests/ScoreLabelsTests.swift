//
//  ScoreLabelsTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation

import XCTest
import SnapshotTesting

class ScoreLabelsTests: XCTestCase {

    func testScoreLabels() throws {

        let model = Model(
            score: 567,
            minScore: 0,
            maxScore: 700
        )

        let viewModel = ScoreLabelsViewModel(model: model)

        let view = ScoreLabels(frame: .zero)
        try view.setViewModel(viewModel, animated: false)
        view.backgroundColor = .black

        let size = view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .defaultLow,
            verticalFittingPriority: .defaultLow
        )

        view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        assertSnapshot(
            matching: view,
            as: .image
        )
    }
}
