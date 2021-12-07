//
//  CAShapeLayerCircleTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
import SnapshotTesting

final class CAShapeLayerCircleTests: XCTestCase {

    func testDrawCircle() {

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.drawCircle(
            fillColor: .red,
            radius: layer.frame.radius
        )

        assertSnapshot(
            matching: layer,
            as: .image
        )
    }

    func testDrawCircleWithStroke() {

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.drawCircle(
            fillColor: .red,
            strokeColor: .yellow,
            strokeWidth: 10.0,
            radius: layer.frame.radius - 5.0
        )

        assertSnapshot(
            matching: layer,
            as: .image
        )
    }

    func testDrawHalfCircleSegment() {

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.drawCircle(
            fillColor: .red,
            degrees: 180,
            radius: layer.frame.radius
        )

        assertSnapshot(
            matching: layer,
            as: .image
        )
    }

    func testDrawQuarterCircleSegment() {

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.drawCircle(
            fillColor: .red,
            degrees: 90,
            radius: layer.frame.radius
        )

        assertSnapshot(
            matching: layer,
            as: .image
        )
    }

    func testDrawThreeQuarterCircleSegment() {

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.drawCircle(
            fillColor: .red,
            strokeColor: .yellow,
            degrees: 270,
            radius: layer.frame.radius - 5.0
        )

        assertSnapshot(
            matching: layer,
            as: .image
        )
    }
}

private extension CGRect {
    var radius: CGFloat {
        width  / 2
    }
}

private final class HostView: UIView {

    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer? {
        layer as? CAShapeLayer
    }

    private let shapeHandler: (CAShapeLayer) -> Void

    init(_ shapeHandler: @escaping (CAShapeLayer) -> Void) {
        self.shapeHandler = shapeHandler
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let layer = self.shapeLayer {
            shapeHandler(layer)
        }
    }
}
