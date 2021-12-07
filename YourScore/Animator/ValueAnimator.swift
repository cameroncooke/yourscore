//
//  ValueAnimator.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import Combine

protocol ValueAnimator {
    var valuePublisher: AnyPublisher<Int, Never> { get }
    var duration: TimeInterval! { get }
    var minValue: Int! { get }
    var maxValue: Int! { get }

    func start()
    func stop()
}
