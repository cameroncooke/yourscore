//
//  TimerFactory.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import QuartzCore

struct TimerFactory {
    var makeTimer: (_ target: Any, _ selector: Selector) -> TimerConformable
}

extension TimerFactory {

    static let live = Self(
        makeTimer: { target, selector in
            CADisplayLink(target: target, selector: selector)
        }
    )
}
