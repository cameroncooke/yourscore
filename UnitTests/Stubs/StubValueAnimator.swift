//
//  StubValueAnimator.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import Combine
@testable import YourScore

final class StubValueAnimator: ValueAnimator {

    var startInvocation: (() -> Int)?
    var stopInvocation: (() -> Void)?

    var valuePublisher: AnyPublisher<Int, Never> { valueSubject.eraseToAnyPublisher() }
    private let valueSubject = PassthroughSubject<Int, Never>()

    var duration: TimeInterval! = 0
    var minValue: Int!
    var maxValue: Int!

    init(minValue: Int, maxValue: Int) {
        self.minValue = minValue
        self.maxValue = maxValue
    }

    func start() {
        guard let invocation = startInvocation else { return }
        let value = invocation()
        
        valueSubject.send(value)
    }

    func stop() {
        guard let invocation = stopInvocation else { return }
        invocation()
    }
}
