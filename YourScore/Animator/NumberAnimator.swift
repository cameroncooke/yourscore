//
//  NumberAnimator.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class NumberAnimator: ValueAnimator {

    enum ValidationError: Error {
        case durationMustBeGreaterThanZero
        case minValueMustBeGreaterThanZero
        case maxValueMustBeGreaterThanZero
        case minValueMustBeLessThanMaxValue
        case maxValueMustBeGreaterThanMinValue
    }

    private var timer: TimerConformable?

    // Uses implicitly unwrapped optionals here to avoid having to
    // unwrap or use nil-coalescing operator which would complicate
    // the implementation. By the time initialization has finished
    // these three properties will have been given values.
    private(set) var duration: TimeInterval!
    private(set) var minValue: Int!
    private(set) var maxValue: Int!

    private let timerFactory: TimerFactory
    private var frame: Double = 0
    private var value: Double = 0

    var valuePublisher: AnyPublisher<Int, Never> { valueSubject.eraseToAnyPublisher() }
    private let valueSubject = PassthroughSubject<Int, Never>()

    init(timerFactory: TimerFactory = .live) {
        self.duration = 1
        self.minValue = 0
        self.maxValue = 1
        self.timerFactory = timerFactory
    }

    init(
        minValue: Int,
        maxValue: Int,
        duration: TimeInterval = 1,
        timerFactory: TimerFactory = .live
    ) throws {

        self.timerFactory = timerFactory

        try update(
            minValue: minValue,
            maxValue: maxValue,
            duration: duration
        )
    }

    func update(minValue: Int, maxValue: Int, duration: TimeInterval) throws {

        guard minValue >= 0 else {
            throw ValidationError.minValueMustBeGreaterThanZero
        }

        guard minValue < maxValue else {
            throw ValidationError.minValueMustBeLessThanMaxValue
        }

        guard duration >= 0 else {
            throw ValidationError.durationMustBeGreaterThanZero
        }

        self.minValue = minValue
        self.maxValue = maxValue
        self.duration = duration
    }

    func start() {
        reset()

        timer?.invalidate()
        timer = timerFactory.makeTimer(self, #selector(didFire(timer:)))
        timer?.add(to: .current, forMode: .default)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func reset() {
        frame = 0
        value = Double(minValue) + 0.499
    }

    @objc
    func didFire(timer: TimerConformable) {

        // Calculate frame rate
        let fps = floor(1 / (timer.targetTimestamp - timer.timestamp))

        // Calculate the total number of frames required to meet the desired duration
        let totalFrames = max(duration * fps, 1)

        // If final frame is reached stop timer
        guard frame < totalFrames else {
            stop()
            return
        }

        // Calculate increment value by dividing the total number to count up to by
        // the number of frames
        let incrementValue = Double(maxValue - minValue) / totalFrames

        // Calculate new value by rounding by 1 decimal place
        let numberOfPlaces = 1.0
        let multiplier = pow(10.0, numberOfPlaces)
        let num = value + incrementValue

        let newValue = (num * multiplier) / multiplier

        // Round the value to nearest whole number and then convert to Int
        // this removes the unwanted decimals.
        //
        // This allows us to calculate the same number for multiple frames
        // for example:
        //
        // frame 1: value 0.499, integerValue = 0
        // frame 2: value 0.987, integerValue = 1
        // frame 3: value 1.497, integerValue = 1
        // frame 4: value 1.996, integerValue = 2
        // frame 5: value 2.495, integerValue = 2
        // frame 6: value 2.994, integerValue = 3
        // etc.
        //
        let integerValue = Int(round(newValue))
        valueSubject.send(integerValue)

        // Update internal state
        frame = frame + 1
        value = newValue
    }
}
