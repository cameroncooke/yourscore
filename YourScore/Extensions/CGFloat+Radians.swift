//
//  CGFloat+Radians.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import UIKit

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
