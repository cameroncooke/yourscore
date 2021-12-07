//
//  ScoreLabels.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import UIKit

class ScoreLabels: UIView {

    private let animator = NumberAnimator()

    private lazy var scoreLabel: AnimatingLabel = {
        let label = AnimatingLabel(animator: animator)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "000"
        label.textColor = .white
        label.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: .monospacedDigitSystemFont(ofSize: 32, weight: .bold))
        label.textAlignment = .right
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.accessibilityLabel = "Your credit score".localized
        return label
    }()

    private lazy var maxScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "out of".localized + " 000"
        label.lineBreakMode = .byTruncatingHead
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.accessibilityLabel = "Maximum possible credit score".localized
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViewModel(_ model: ScoreLabelsViewModel, animated: Bool) throws {

        if animated {
            try animator.update(
                minValue: 0,
                maxValue: model.score,
                duration: 1
            )
        } else {
            scoreLabel.updateText(for: model.score)
        }

        scoreLabel.accessibilityValue = String(model.score)

        maxScoreLabel.text = model.maxScoreLabelText
        maxScoreLabel.accessibilityValue = String(model.maxScore)
    }

    func startAnimating() {
        scoreLabel.startAnimating()
    }

    private func setupSubviews() {
        setupLabels()
    }

    private func setupLabels() {

        // "Score" title label
        let scoreTitleLabel = UILabel()
        scoreTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreTitleLabel.text = "Score".localized
        scoreTitleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        scoreTitleLabel.adjustsFontForContentSizeCategory = true
        scoreTitleLabel.adjustsFontSizeToFitWidth = true
        scoreTitleLabel.textColor = .white
        scoreTitleLabel.textAlignment = .center
        addSubview(scoreTitleLabel)

        NSLayoutConstraint.activate([
            scoreTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            scoreTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            scoreTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // Container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: scoreTitleLabel.bottomAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        // Score label
        container.addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: container.topAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        // Max score label
        container.addSubview(maxScoreLabel)

        NSLayoutConstraint.activate([
            maxScoreLabel.lastBaselineAnchor.constraint(equalTo: scoreLabel.lastBaselineAnchor),
            maxScoreLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            maxScoreLabel.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 8)
        ])
    }
}
