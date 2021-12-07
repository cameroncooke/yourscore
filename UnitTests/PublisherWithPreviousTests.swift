//
//  PublisherWithPreviousTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import XCTest
import Combine
@testable import YourScore

final class PublisherWithPreviousTests: XCTestCase {

    func testPublisherEmitsCurrentAndNilPreviousValue() throws {

        let subject = PassthroughSubject<String, Never>()

        var values: (previous: String?, current: String)?

        let cancellation = subject
            .withPrevious
            .sink { tuple in
                values = tuple
            }

        subject.send("Hello")

        let current = try XCTUnwrap(values).current
        let previous  = try XCTUnwrap(values).previous

        XCTAssertEqual(current, "Hello")
        XCTAssertNil(previous)

        cancellation.cancel()
    }

    func testPublisherEmitsCurrentAndPreviousValue() throws {

        let subject = PassthroughSubject<String, Never>()

        var values: (previous: String?, current: String)?

        let cancellation = subject
            .withPrevious
            .sink { tuple in
                values = tuple
            }

        subject.send(", World")
        subject.send("Hello")

        let current = try XCTUnwrap(values).current
        let previous  = try XCTUnwrap(values).previous

        XCTAssertEqual(current, "Hello")
        XCTAssertEqual(previous, ", World")

        cancellation.cancel()
    }
}
