//
//  AnimatingLabelTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import SnapshotTesting

class AnimatingLabelTests: XCTestCase {

    func testAnimatingLabelInitalValue() {

        let animator = StubValueAnimator(minValue: 100, maxValue: 700)

        let label = AnimatingLabel(animator: animator)

        assertSnapshot(
            matching: label,
            as: .image
        )
    }

    func testAnimatingLabelShowPublishedValueFromValueAnimator() {

        let animator = StubValueAnimator(minValue: 0, maxValue: 700)
        animator.startInvocation = {
            return 456
        }


        let label = AnimatingLabel(animator: animator)
        label.startAnimating()

        assertSnapshot(
            matching: label,
            as: .image
        )
    }
}
