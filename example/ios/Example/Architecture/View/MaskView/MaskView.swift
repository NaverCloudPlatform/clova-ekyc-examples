/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class MaskView: UIView {

    private let cropLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.6)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MaskView {

    func makeMask(with bezierPath: UIBezierPath) {
        cropLayer.frame = bounds
        cropLayer.fillRule = .evenOdd
        let path = UIBezierPath(rect: bounds)
        path.append(bezierPath)
        cropLayer.path = path.cgPath
        layer.mask = cropLayer
    }
}
