//
//  Publisher+WithPrevious.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import Combine

extension Publisher {

    public var withPrevious: AnyPublisher<(previous: Output?, current: Output), Failure> {
        
        self.map { output -> Output? in output }
            .scan((nil, nil)) { ($0.1, $1) }
            .compactMap { previous, current -> (previous: Self.Output?, current: Self.Output)? in
                guard let current = current else { return nil }
                return (previous, current)
            }
            .eraseToAnyPublisher()
    }
}
