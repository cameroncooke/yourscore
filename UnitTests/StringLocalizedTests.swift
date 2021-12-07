//
//  String+LocalisedTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import XCTest
@testable import YourScore

final class StringLocalizedTests: XCTestCase {

    func testLocalizedReturnsLocalizedString() {
        let string = "hello, world"
        XCTAssertEqual(string.localized, "Bonjour le monde")
    }
}
