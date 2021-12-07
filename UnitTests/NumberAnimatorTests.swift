//
//  NumberAnimatorTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import Combine
@testable import YourScore

final class NumberAnimatorTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    func testInitWithNoArgumentsSetsDefaultValues() {

        let animator = NumberAnimator()

        XCTAssertEqual(animator.minValue, 0)
        XCTAssertEqual(animator.maxValue, 1)
        XCTAssertEqual(animator.duration, 1)
    }

    func testInitWithMinValueMaxValueDurationSetsValues() throws {

        let animator = try NumberAnimator(
            minValue: 50,
            maxValue: 100,
            duration: 5
        )

        XCTAssertEqual(animator.minValue, 50)
        XCTAssertEqual(animator.maxValue, 100)
        XCTAssertEqual(animator.duration, 5)
    }

    func testInitWithNegativeMinValueThrowsError() {

        XCTAssertThrowsError(
            try NumberAnimator(
                minValue: -5,
                maxValue: 50,
                duration: 1
            )
        ) { error in
            XCTAssertEqual(
                error as? NumberAnimator.ValidationError,
                .minValueMustBeGreaterThanZero
            )
        }
    }

    func testInitWithMinValueGreaterThanMaxValueThrowsError() {

        XCTAssertThrowsError(
            try NumberAnimator(
                minValue: 100,
                maxValue: 50,
                duration: 1
            )
        ) { error in
            XCTAssertEqual(
                error as? NumberAnimator.ValidationError,
                .minValueMustBeLessThanMaxValue
            )
        }
    }

    func testInitWithNegativeDurationValueThrowsError() {

        XCTAssertThrowsError(
            try NumberAnimator(
                minValue: 0,
                maxValue: 100,
                duration: -5
            )
        ) { error in
            XCTAssertEqual(
                error as? NumberAnimator.ValidationError,
                .durationMustBeGreaterThanZero
            )
        }
    }

    func testUpdateWithMinValueMaxValueDurationSetsValues() throws {

        let animator = NumberAnimator()
        try animator.update(
            minValue: 50,
            maxValue: 100,
            duration: 5
        )

        XCTAssertEqual(animator.minValue, 50)
        XCTAssertEqual(animator.maxValue, 100)
        XCTAssertEqual(animator.duration, 5)
    }

    func testUpdateMinValueWithNegativeMinValueThrowsError() {

        let animator = NumberAnimator()

        XCTAssertThrowsError(
            try animator.update(
                minValue: -5,
                maxValue: 50,
                duration: 1
            )
        ) { error in
            XCTAssertEqual(
                error as? NumberAnimator.ValidationError,
                .minValueMustBeGreaterThanZero
            )
        }
    }

    func testUpdateWithMinValueGreaterThanMaxValueThrowsError() {

        let animator = NumberAnimator()

        XCTAssertThrowsError(
            try animator.update(
                minValue: 100,
                maxValue: 50,
                duration: 1
            )
        ) { error in
            XCTAssertEqual(
                error as? NumberAnimator.ValidationError,
                .minValueMustBeLessThanMaxValue
            )
        }
    }

    func testUpdateWithNegativeDurationValueThrowsError() {

        let animator = NumberAnimator()

        XCTAssertThrowsError(
            try animator.update(
                minValue: 0,
                maxValue: 100,
                duration: -5
            )
        ) { error in
            XCTAssertEqual(
                error as? NumberAnimator.ValidationError,
                .durationMustBeGreaterThanZero
            )
        }
    }

    func testStartMethodEmitsMaxValue() throws {

        let stubTimer = StubTimer()

        let animator = try NumberAnimator(
            minValue: 0,
            maxValue: 700,
            duration: 0,
            timerFactory: .stub(timer: stubTimer)
        )

        var value: Int?

        animator.valuePublisher
            .sink {
                value = $0
            }
            .store(in: &cancellables)

        animator.start()
        stubTimer.fire()

        XCTAssertEqual(try XCTUnwrap(value), 700)
    }

    func testAnimatorPublishesSequentialValuesWhenFrameRateAndValuesAreTheSame () throws {

        let stubTimer = StubTimer(frameRate: 10)

        let animator = try NumberAnimator(
            minValue: 0,
            maxValue: 10,
            duration: 1,
            timerFactory: .stub(timer: stubTimer)
        )

        var values = [Int]()

        animator.valuePublisher
            .sink {
                values.append($0)
            }
            .store(in: &cancellables)

        animator.start()

        while(true) {
            let didFire = stubTimer.fire()
            if !didFire { break }
        }

        XCTAssertEqual(
            values,
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    }

    func testAnimatorPublishesDuplicatedSequentialValuesWhenFrameRateIsDoubleTheTotalValueRange() throws {

        let stubTimer = StubTimer(frameRate: 20)

        let animator = try NumberAnimator(
            minValue: 0,
            maxValue: 10,
            duration: 1,
            timerFactory: .stub(timer: stubTimer)
        )

        var values = [Int]()

        animator.valuePublisher
            .sink {
                values.append($0)
            }
            .store(in: &cancellables)

        animator.start()

        while(true) {
            let didFire = stubTimer.fire()
            if !didFire { break }
        }

        XCTAssertEqual(
            values,
            [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10])
    }

    func testAnimatorPublishesStridedByTwoValuesWhenFrameRateIsHalfTheTotalValueRange() throws {

        let stubTimer = StubTimer(frameRate: 10)

        let animator = try NumberAnimator(
            minValue: 0,
            maxValue: 20,
            duration: 1,
            timerFactory: .stub(timer: stubTimer)
        )

        var values = [Int]()

        animator.valuePublisher
            .sink {
                values.append($0)
            }
            .store(in: &cancellables)

        animator.start()

        while(true) {
            let didFire = stubTimer.fire()
            if !didFire { break }
        }

        XCTAssertEqual(
            values,
            [2, 4, 6, 8, 10, 12, 14, 16, 18, 20])
    }

    func testAnimatorPublishesSequentialValuesWhenFrameRateAndValuesAreTheSameWithNonZeroMinValue () throws {

        let stubTimer = StubTimer(frameRate: 10)

        let animator = try NumberAnimator(
            minValue: 4,
            maxValue: 14,
            duration: 1,
            timerFactory: .stub(timer: stubTimer)
        )

        var values = [Int]()

        animator.valuePublisher
            .sink {
                values.append($0)
            }
            .store(in: &cancellables)

        animator.start()

        while(true) {
            let didFire = stubTimer.fire()
            if !didFire { break }
        }

        XCTAssertEqual(
            values,
            [5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    }
}
