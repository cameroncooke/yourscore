//
//  StubTimer.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
@testable import YourScore

final class StubTimer: NSObject, TimerConformable {

    let targetTimestamp: CFTimeInterval
    let timestamp: CFTimeInterval

    private var target: Any?
    private var selector: Selector?
    private var isStopped = true

    init(frameRate: Double = 60) {
        timestamp = 0
        targetTimestamp = 1 / frameRate
    }

    func setTarget(_ target: Any, selector: Selector) {
        self.target = target
        self.selector = selector
    }

    func add(to runLoop: RunLoop, forMode mode: RunLoop.Mode) {
        isStopped = false
    }

    func invalidate() {
        isStopped = true
    }

    // Returns true if successfully fired
    @discardableResult
    func fire() -> Bool {

        guard !isStopped else {
            return false
        }

        guard let target = target as AnyObject? else {
            return false
        }

        guard let selector = selector else {
            return false
        }

        _ = target.perform(selector, with: self)

        return true
    }
}

extension TimerFactory {

    static func stub(timer: StubTimer) -> Self {
        Self(
            makeTimer: { target, selector in
                timer.setTarget(target, selector: selector)
                return timer
            }
        )
    }
}
