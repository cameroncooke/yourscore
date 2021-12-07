//
//  ScoreView.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import UIKit
import Combine

final class ScoreView: UIView {

    private let viewModel: ScoreViewViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    private lazy var circularView: CircularView = {
        let circularView = CircularView()
        circularView.translatesAutoresizingMaskIntoConstraints = false
        return circularView
    }()

    private lazy var ringView: RingView = {
        let ringView = RingView()
        ringView.translatesAutoresizingMaskIntoConstraints = false
        return ringView
    }()

    private lazy var labelsView: ScoreLabels = {
        let labelsView = ScoreLabels()
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        labelsView.isHidden = true
        return labelsView
    }()

    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Calculating Score...".localized
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var errorTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Failed to load score, retry?".localized
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingMiddle
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var retryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "arrow.clockwise")
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .gray
        config.cornerStyle = .capsule

        let button = UIButton(
            configuration: config,
            primaryAction: .init { [weak self] _ in self?.viewModel.retryAction()  }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityHint = "Retries the loading of your credit score"
        button.accessibilityLabel = "Retry"

        return button
    }()

    init(viewModel: ScoreViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupSubviews()
        subscribeToAnimationDidEndPublisher()
        subscribeToStateChangePublisher()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        circularView.frame = blurView.bounds
        blurView.layer.mask = circularView.layer
    }

    private func setupSubviews() {
        setupCircles()
        setupLabels()
    }

    private func setupCircles() {

        // Circular view (Blur view)
        addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Ring view
        addSubview(ringView)

        NSLayoutConstraint.activate([
            ringView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ringView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ringView.topAnchor.constraint(equalTo: topAnchor),
            ringView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        if viewModel.animated {
            ringView.addAnimation(animationStrategy: .indeterministic)
        }
    }

    private func setupLabels() {

        // Score labels
        addSubview(labelsView)

        NSLayoutConstraint.activate([
            labelsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsView.topAnchor.constraint(greaterThanOrEqualTo: ringView.safeAreaLayoutGuide.topAnchor),
            labelsView.bottomAnchor.constraint(lessThanOrEqualTo: ringView.safeAreaLayoutGuide.bottomAnchor),
            labelsView.leadingAnchor.constraint(greaterThanOrEqualTo: ringView.safeAreaLayoutGuide.leadingAnchor),
            labelsView.trailingAnchor.constraint(lessThanOrEqualTo: ringView.safeAreaLayoutGuide.trailingAnchor)
        ])


        // Loading label
        addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingLabel.topAnchor.constraint(greaterThanOrEqualTo: ringView.safeAreaLayoutGuide.topAnchor),
            loadingLabel.bottomAnchor.constraint(lessThanOrEqualTo: ringView.safeAreaLayoutGuide.bottomAnchor),
            loadingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: ringView.safeAreaLayoutGuide.leadingAnchor),
            loadingLabel.trailingAnchor.constraint(lessThanOrEqualTo: ringView.safeAreaLayoutGuide.trailingAnchor)
        ])

        // Retry button
        addSubview(retryButton)

        NSLayoutConstraint.activate([
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            retryButton.topAnchor.constraint(greaterThanOrEqualTo: ringView.safeAreaLayoutGuide.topAnchor),
            retryButton.bottomAnchor.constraint(lessThanOrEqualTo: ringView.safeAreaLayoutGuide.bottomAnchor),
            retryButton.leadingAnchor.constraint(greaterThanOrEqualTo: ringView.safeAreaLayoutGuide.leadingAnchor),
            retryButton.trailingAnchor.constraint(lessThanOrEqualTo: ringView.safeAreaLayoutGuide.trailingAnchor)
        ])

        // Error title
        addSubview(errorTitle)

        NSLayoutConstraint.activate([
            errorTitle.topAnchor.constraint(greaterThanOrEqualTo: ringView.safeAreaLayoutGuide.topAnchor),
            errorTitle.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: -16),
            errorTitle.leadingAnchor.constraint(equalTo: ringView.safeAreaLayoutGuide.leadingAnchor),
            errorTitle.trailingAnchor.constraint(equalTo: ringView.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // Be notified when an animation pass completes
    private func subscribeToAnimationDidEndPublisher() {
        ringView.animationDidEndPublisher
            .flatMap {
                Just(self.viewModel.state)
                    .eraseToAnyPublisher()
            }
            .withPrevious
            .sink { [weak self] state in

                guard let self = self else { return }

                switch state.current {
                case .loading:
                    self.ringView.addAnimation(animationStrategy: .indeterministic)

                case .loaded(let viewModel) where state.previous == .loaded(model: viewModel):
                    self.ringView.setPercentageComplete(self.viewModel.percentageComplete)
                    self.ringView.removeAllAnimations()

                case .loaded:
                    self.ringView.removeAnimation(animationStrategy: .indeterministic)
                    self.ringView.addAnimation(animationStrategy: .deterministic(percentageComplete: self.viewModel.percentageComplete))
                    self.labelsView.startAnimating()

                case .failed where state.previous == .failed:
                    self.ringView.removeAllAnimations()

                case .failed:
                    self.ringView.setPercentageComplete(self.viewModel.percentageComplete)
                    self.ringView.removeAllAnimations()
                    self.ringView.addAnimation(animationStrategy: .failure)
                }
            }
            .store(in: &cancellables)
    }

    // Be notified when an view model "state" changes
    private func subscribeToStateChangePublisher() {
        viewModel.statePublisher
            .sink { [weak self] state in

                guard let self = self else { return }

                switch state {
                case .loading:
                    self.loadingLabel.isHidden = false
                    self.labelsView.isHidden = true
                    self.retryButton.isHidden = true
                    self.errorTitle.isHidden  = true
                    self.ringView.setStrokeColor(.white)

                case .loaded(let viewModel):
                    try? self.labelsView.setViewModel(viewModel, animated: self.viewModel.animated)

                    if !self.viewModel.animated {
                        self.ringView.setPercentageComplete(self.viewModel.percentageComplete)
                    }

                    self.loadingLabel.isHidden = true
                    self.labelsView.isHidden = false
                    self.retryButton.isHidden = true
                    self.errorTitle.isHidden  = true
                    self.ringView.setStrokeColor(.white)

                case .failed:
                    self.loadingLabel.isHidden = true
                    self.labelsView.isHidden = true
                    self.retryButton.isHidden = false
                    self.errorTitle.isHidden  = false

                    self.ringView.setStrokeColor(
                        UIColor(
                            named: "ErrorRed",
                            in: Bundle.module,
                            compatibleWith: nil
                        )!
                    )
                }
            }
            .store(in: &cancellables)
    }
}

