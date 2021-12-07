//
//  AnimatingLabelTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import Combine
@testable import YourScore

final class AnimatingLabelTests: XCTestCase {

    func testTextHasFourLeadingZerosWhenMaxValueIsInTheThousandsAndMinValueIsZero() {

        let animator = StubValueAnimator(minValue: 0, maxValue: 7000)
        let label = AnimatingLabel(animator: animator)

        XCTAssertEqual(label.text, "0000")
    }

    func testTextHasThreeLeadingZerosWhenMaxValueIsInTheHundredsAndMinValueIsZero() {

        let animator = StubValueAnimator(minValue: 0, maxValue: 700)
        let label = AnimatingLabel(animator: animator)

        XCTAssertEqual(label.text, "000")
    }

    func testTextHasTwoLeadingZerosWhenMaxValueIsInTheTensAndMinValueIsZero() {

        let animator = StubValueAnimator(minValue: 0, maxValue: 70)
        let label = AnimatingLabel(animator: animator)

        XCTAssertEqual(label.text, "00")
    }

    func testTextHasOneLeadingZerosWhenMaxValueIsInTheOnesAndMinValueIsZero() {

        let animator = StubValueAnimator(minValue: 0, maxValue: 7)
        let label = AnimatingLabel(animator: animator)

        XCTAssertEqual(label.text, "0")
    }

    func testTextHasExpectedLeadingZerosWhenMaxValueIsInTheThousandsAndMinValueIsZero() {

        let animator = StubValueAnimator(minValue: 70, maxValue: 7000)
        let label = AnimatingLabel(animator: animator)

        XCTAssertEqual(label.text, "0070")
    }

    func testTextHasExpectedLeadingZerosWhenMaxValueIsInTheHundredsAndMinValueIsSeventy() {

        let animator = StubValueAnimator(minValue: 70, maxValue: 700)
        let label = AnimatingLabel(animator: animator)

        XCTAssertEqual(label.text, "070")
    }

    func testTextHasExpectedLeadingZerosWhenMaxValueIsInTheTensAndMinValueIsSeventy() {

        let animator = StubValueAnimator(minValue: 70, maxValue: 70)
        let label = AnimatingLabel(animator: animator)

        XCTAssertEqual(label.text, "70")
    }

    func testTextHasExpectedLeadingZerosWhenMaxValueIsInTheOnesAndMinValueIsSeven() {

        let animator = StubValueAnimator(minValue: 7, maxValue: 7)
        let label = AnimatingLabel(animator: animator)

        XCTAssertEqual(label.text, "7")
    }

    func testTextMatchesExpectedValueWhenMaxValueIsPublishedByAnimator() {

        let animator = StubValueAnimator(minValue: 0, maxValue: 700)
        animator.startInvocation = { 700 }

        let label = AnimatingLabel(animator: animator)
        label.startAnimating()

        XCTAssertEqual(label.text, "700")
    }

    func testTextMatchesExpectedValueWhenOtherValueIsPublishedByAnimator() {

        let animator = StubValueAnimator(minValue: 0, maxValue: 700)
        animator.startInvocation = { 45 }

        let label = AnimatingLabel(animator: animator)
        label.startAnimating()

        XCTAssertEqual(label.text, "045")
    }

    func testStartAnimatingCallsAnimatorStart() {

        var didCallStartMethod: Bool?

        let animator = StubValueAnimator(minValue: 0, maxValue: 700)
        animator.startInvocation = {
            didCallStartMethod = true
            return 0
        }

        let label = AnimatingLabel(animator: animator)
        label.startAnimating()

        XCTAssertTrue(try XCTUnwrap(didCallStartMethod))
    }

    func testStopAnimatingCallsAnimatorStop() {

        var didCallStopMethod: Bool?

        let animator = StubValueAnimator(minValue: 0, maxValue: 700)
        animator.stopInvocation = {
            didCallStopMethod = true
        }

        let label = AnimatingLabel(animator: animator)
        label.stopAnimating()

        XCTAssertTrue(try XCTUnwrap(didCallStopMethod))
    }
}
