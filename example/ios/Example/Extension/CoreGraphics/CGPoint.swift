/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreGraphics

extension CGPoint {

    enum AspectType {
        case fill
        case fit
    }

    func changeScale(to targetSize: CGSize, parentScreenSize: CGSize, aspectType: AspectType = .fill) -> CGPoint {
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
            x = self.x * aspectRatio + (targetSize.width - weightSize.width) / 2
            y = self.y * aspectRatio
        } else {
            x = self.x * aspectRatio
            y = self.y * aspectRatio + (targetSize.height - weightSize.height) / 2
        }

        return CGPoint(x: x, y: y)
    }
}
