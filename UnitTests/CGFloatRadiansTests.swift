//
//  CGFloatRadiansTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import XCTest
@testable import YourScore

final class CGFloatRadiansTests: XCTestCase {

    func testToRadians() {
        let degrees: CGFloat = 360
        XCTAssertEqual(degrees.toRadians(), 6.283185307179586)
    }
}
