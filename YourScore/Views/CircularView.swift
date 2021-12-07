//
//  CircularView.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import UIKit

final class CircularView: UIView {

    private var radius: CGFloat {
        bounds.width / 2
    }

    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer? {
        layer as? CAShapeLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        shapeLayer?.drawCircle(
            fillColor: .black,
            radius: radius
        )
    }
}
