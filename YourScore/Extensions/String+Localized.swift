//
//  String+Localized.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
