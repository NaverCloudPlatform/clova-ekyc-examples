/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

extension UIView {

    func makeRoundBorder(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }

    func removeAllSublayers() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        layer.sublayers?.removeAll()
    }

    func drawLine(from start: CGPoint, to end: CGPoint, color: UIColor?) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = color?.cgColor
        line.lineWidth = 1.5
        line.lineJoin = CAShapeLayerLineJoin.round
        layer.addSublayer(line)
    }
}
