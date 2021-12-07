//
//  TimerFactoryTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import Combine
@testable import YourScore

final class TimerFactoryTests: XCTestCase {

    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()

        expectation = XCTestExpectation(description: "Timer fired")
    }

    func testCanMakeCADisplayLink() {

        let factory: TimerFactory = .live
        let timer = factory.makeTimer(self, #selector(timerDidFire))

        XCTAssertNotNil(timer as? CADisplayLink)
    }

    func testDisplayLinkSetsTargetAndSelector() {

        let factory: TimerFactory = .live

        let timer = factory.makeTimer(self, #selector(timerDidFire))
        timer.add(to: .current, forMode: .default)

        wait(for: [expectation], timeout: 1)
    }

    @objc
    func timerDidFire() {
        expectation.fulfill()
    }
}
