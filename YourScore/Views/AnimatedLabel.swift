//
//  AnimatedLabel.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import UIKit
import Combine

class AnimatingLabel: UILabel {

    private let animator: ValueAnimator
    private var cancellable: AnyCancellable?

    init(animator: ValueAnimator) {
        self.animator = animator
        super.init(frame: .zero)

        updateText(for: animator.minValue)
        subscribeToAnimatorValue()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func subscribeToAnimatorValue() {
        cancellable  = animator.valuePublisher
            .sink { [weak self] value in

                guard let self = self else { return }
                self.updateText(for: value)
            }
    }

    func startAnimating() {
        animator.start()
    }

    func stopAnimating() {
        animator.stop()
    }

    func updateText(for value: Int) {
        let numberOfPlaces = String(animator.maxValue).count
        self.text = String(format: "%0\(numberOfPlaces)d", value)
    }
}

