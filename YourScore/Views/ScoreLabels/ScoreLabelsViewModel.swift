//
//  ScoreLabelsViewModel.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation

final class ScoreLabelsViewModel {

    let model: Model

    init(model: Model) {
        self.model = model
    }

    var score: Int {
        model.score
    }

    var maxScore: Int {
        model.maxScore
    }

    var maxScoreLabelText: String {
        "out of".localized + " " + String(model.maxScore)
    }
}

extension ScoreLabelsViewModel: Equatable {

    static func == (lhs: ScoreLabelsViewModel, rhs: ScoreLabelsViewModel) -> Bool {
        lhs.model == rhs.model
    }
}
