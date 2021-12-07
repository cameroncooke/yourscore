//
//  CircleLayer.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import UIKit

extension CAShapeLayer {

    func drawCircle(
        fillColor: UIColor = .white,
        strokeColor: UIColor = .black,
        strokeWidth: CGFloat = 0,
        degrees: CGFloat = 360,
        radius: CGFloat
    ) {

        let path = UIBezierPath(
            arcCenter: CGPoint(
                x: frame.midX,
                y: frame.midY
            ),
            radius: radius,
            startAngle: CGFloat(-90).toRadians(),
            endAngle: CGFloat(degrees-90).toRadians(),
            clockwise: true
        )

        if strokeWidth == 0 {
            path.addLine(to: CGPoint(x: frame.midX, y: frame.midY))
        }

        self.path = path.cgPath
        self.fillColor = fillColor.cgColor
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = strokeWidth
        self.lineCap = .round
        self.fillRule = .evenOdd
    }
}
