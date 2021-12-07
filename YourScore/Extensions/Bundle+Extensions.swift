//
//  Bundle+Extensions.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation

final class Dummy {}

extension Bundle {
    static var module: Bundle {
        Bundle(for: Dummy.self)
    }
}
