//
//  CircularView.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class RingView: UIView {

    private static let strokeWidth: CGFloat = 20.0

    private var radius: CGFloat {
        bounds.width / 2 - Self.strokeWidth
    }

    enum AnimationStrategy {
        case indeterministic
        case deterministic(percentageComplete: CGFloat)
        case failure
        case none
    }

    private var animationDidEndSubject = PassthroughSubject<Void, Never>()
    var animationDidEndPublisher: AnyPublisher<Void, Never> { animationDidEndSubject.eraseToAnyPublisher() }

    lazy private var _safeAreaLayoutGuide = UILayoutGuide()
    override var safeAreaLayoutGuide: UILayoutGuide { _safeAreaLayoutGuide }

    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer? {
        layer as? CAShapeLayer
    }

    private var strokeColor = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayoutGuides()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        shapeLayer?.drawCircle(
            fillColor: .clear,
            strokeColor: strokeColor,
            strokeWidth: Self.strokeWidth,
            radius: radius
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsUpdateConstraints()

        // This shouldn't be needed but for some reason when snapshot
        // testing the layer's origin isn't kept in sync with the view
        // if any auto layout constraints are in play.
        layer.frame = bounds
    }

    func setStrokeColor(_ color: UIColor) {
        strokeColor = color
        setNeedsLayout()
    }

    private func setupLayoutGuides() {
        addLayoutGuide(_safeAreaLayoutGuide)

        topConstraint =  _safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        topConstraint?.isActive = true

        bottomConstraint = _safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottomConstraint?.isActive = true

        leadingConstraint = _safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        leadingConstraint?.isActive = true

        trailingConstraint = _safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        trailingConstraint?.isActive = true
    }

    override func updateConstraints() {
        super.updateConstraints()

        // Circumscribe a square within the radius of the circle to calculate
        // offsets needed on the safe area layout guides.
        let radius: CGFloat = radius
        let side: CGFloat = (radius * radius * 2).squareRoot()
        let half = side * 0.5

        let center = self.center
        let x = center.x - half
        let y = center.y - half

        topConstraint?.constant = y
        bottomConstraint?.constant = -y
        leadingConstraint?.constant = x
        trailingConstraint?.constant = -x
    }
}

extension RingView {

    func addAnimation(
        animationStrategy: AnimationStrategy
    ) {
        guard let animations = animationStrategy.animation else {
            return
        }

        animations.delegate = self
        layer.add(animations, forKey: animationStrategy.key)
    }

    func removeAnimation(
        animationStrategy: AnimationStrategy
    ) {
        guard let key = animationStrategy.key else { return }
        layer.removeAnimation(forKey: key)
    }

    func removeAllAnimations() {
        layer.removeAllAnimations()
    }

    func setPercentageComplete(_ percentageComplete: CGFloat) {
        shapeLayer?.strokeEnd = percentageComplete
    }
}

extension RingView.AnimationStrategy: Equatable {

    var animation: CAAnimation? {
        switch self {
        case .indeterministic:
            let startAnimation = CABasicAnimation(keyPath: "strokeStart")
            startAnimation.duration = 0.75
            startAnimation.fromValue = 0.0
            startAnimation.toValue = 1.0
            startAnimation.beginTime = 0.25
            startAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
            endAnimation.duration = 0.75
            endAnimation.fromValue = 0.0
            endAnimation.toValue = 1.0
            endAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            let group = CAAnimationGroup()
            group.duration = 1.0
            group.repeatDuration = 1
            group.isRemovedOnCompletion = false
            group.animations = [startAnimation, endAnimation]
            group.fillMode = .forwards
            return group

        case .deterministic(let percentageComplete):
            let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
            drawAnimation.duration = 1.0
            drawAnimation.fromValue = 0.0
            drawAnimation.toValue = percentageComplete
            drawAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            drawAnimation.isRemovedOnCompletion = false
            drawAnimation.fillMode = .forwards
            return drawAnimation

        case .failure:
            let startAnimation = CABasicAnimation(keyPath: "transform.scale")
            startAnimation.duration = 0.1
            startAnimation.fromValue = 1.0
            startAnimation.toValue = 1.1
            startAnimation.isRemovedOnCompletion = false
            startAnimation.fillMode = .forwards

            let endAnimation = CABasicAnimation(keyPath: "transform.scale")
            startAnimation.duration = 0.1
            endAnimation.fromValue = 1.1
            endAnimation.toValue = 1.0
            endAnimation.beginTime = 0.1
            endAnimation.isRemovedOnCompletion = false
            endAnimation.fillMode = .forwards

            let group = CAAnimationGroup()
            group.duration = 0.2
            group.animations = [startAnimation, endAnimation]
            group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            return group

        case .none:
            return nil
        }
    }

    var key: String? {
        switch self {
        case .indeterministic:
            return "indeterministic"
        case .deterministic:
            return "deterministic"
        case .failure:
            return "failure"
        case .none:
            return nil
        }
    }
}

extension RingView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        animationDidEndSubject.send()
    }
}
