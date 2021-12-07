//
//  TimerConformable.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation

@objc
protocol TimerConformable: AnyObject {

    @objc(addToRunLoop:forMode:)
    func add(to runloop: RunLoop, forMode mode: RunLoop.Mode)

    func invalidate()

    var targetTimestamp: CFTimeInterval { get }
    var timestamp: CFTimeInterval { get }
}
