/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreGraphics

extension CGRect {

    enum AspectType {
        case fill
        case fit
    }

    mutating func add(margin: CGFloat) {
        if origin.x > margin, origin.y > margin  {
            origin.x -= margin
            size.width += (2 * margin)
            origin.y -= margin
            size.height += (2 * margin)
        } else {
            let xMargin = origin.x
            origin.x = .zero
            size.width += (2 * xMargin)
            let yMargin = origin.y
            origin.y = .zero
            size.height += (2 * yMargin)
        }
    }

    func changeScale(to targetSize: CGSize, parentScreenSize: CGSize, aspectType: AspectType = .fill) -> CGRect {
        let aspectRatioOfImage = targetSize.width / targetSize.height
        let aspectRatioOfParent = parentScreenSize.width / parentScreenSize.height

        let aspectRatio: CGFloat
        let isFittedVertically: Bool

        let isScaledToVertically: Bool
        if aspectType == .fill {
            isScaledToVertically = aspectRatioOfImage > aspectRatioOfParent
        } else {
            isScaledToVertically = aspectRatioOfImage < aspectRatioOfParent
        }

        if isScaledToVertically {
            aspectRatio = targetSize.width / parentScreenSize.width
            isFittedVertically = false
        } else {
            aspectRatio = targetSize.height / parentScreenSize.height
            isFittedVertically = true
        }

        let weightSize = CGSize(width: parentScreenSize.width * aspectRatio, height: parentScreenSize.height * aspectRatio)

        let x: CGFloat
        let y: CGFloat

        if isFittedVertically {
            x = origin.x * aspectRatio + (targetSize.width - weightSize.width) / 2
            y = origin.y * aspectRatio
        } else {
            x = origin.x * aspectRatio
            y = origin.y * aspectRatio + (targetSize.height - weightSize.height) / 2
        }

        return CGRect(x: x, y: y, width: size.width * aspectRatio, height: size.height * aspectRatio)
    }
}
