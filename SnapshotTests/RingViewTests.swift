//
//  RingViewTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import SnapshotTesting

final class RingViewTests: XCTestCase {

    func testRingView() {

        let view = RingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.setStrokeColor(.red)

        assertSnapshot(
            matching: view,
            as: .image
        )
    }
}
