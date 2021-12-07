//
//  Model.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation

struct Model: Equatable {
    let score: Int
    let minScore: Int
    let maxScore: Int
}

extension Model: Decodable {

    enum CodingKeys: String, CodingKey {
        case score
        case minScore = "minScoreValue"
        case maxScore = "maxScoreValue"
        case creditReportInfo
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let infoContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .creditReportInfo)

        self.score = try infoContainer.decode(Int.self, forKey: .score)
        self.minScore = try infoContainer.decode(Int.self, forKey: .minScore)
        self.maxScore = try infoContainer.decode(Int.self, forKey: .maxScore)
    }
}
