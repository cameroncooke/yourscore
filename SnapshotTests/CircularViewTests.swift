//
//  CircularViewTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import SnapshotTesting

class CircularViewTests: XCTestCase {

    func testCircularView() {

        let view = CircularView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        assertSnapshot(
            matching: view,
            as: .image
        )
    }
}
