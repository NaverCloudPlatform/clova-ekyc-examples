/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class FaceGuideView: UIView {

    private let topLeftImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.guide_top_left.uiImage
        return $0
    }(UIImageView())

    private let topRightImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.guide_top_right.uiImage
        return $0
    }(UIImageView())

    private let bottomLeftImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.guide_bottom_left.uiImage
        return $0
    }(UIImageView())

    private let bottomRightImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.guide_bottom_right.uiImage
        return $0
    }(UIImageView())
    
    init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FaceGuideView {

    func showGrid() {
        topLeftImageView.isHidden = false
        topRightImageView.isHidden = false
        bottomLeftImageView.isHidden = false
        bottomRightImageView.isHidden = false
        layer.borderWidth = .zero
    }

    func showGreenBorder() {
        topLeftImageView.isHidden = true
        topRightImageView.isHidden = true
        bottomLeftImageView.isHidden = true
        bottomRightImageView.isHidden = true
        layer.borderColor = AssetColor.clovaGreen.uiColor?.cgColor
        layer.borderWidth = 4
    }
}

extension FaceGuideView {

    private func configureLayout() {
        backgroundColor = .clear
        addSubview(topLeftImageView)
        NSLayoutConstraint.activate([
            topLeftImageView.topAnchor.constraint(equalTo: topAnchor),
            topLeftImageView.leftAnchor.constraint(equalTo: leftAnchor),
            topLeftImageView.widthAnchor.constraint(equalToConstant: 25),
            topLeftImageView.heightAnchor.constraint(equalToConstant: 25)
        ])

        addSubview(topRightImageView)
        NSLayoutConstraint.activate([
            topRightImageView.topAnchor.constraint(equalTo: topAnchor),
            topRightImageView.rightAnchor.constraint(equalTo: rightAnchor),
            topRightImageView.widthAnchor.constraint(equalToConstant: 25),
            topRightImageView.heightAnchor.constraint(equalToConstant: 25)
        ])

        addSubview(bottomLeftImageView)
        NSLayoutConstraint.activate([
            bottomLeftImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLeftImageView.leftAnchor.constraint(equalTo: leftAnchor),
            bottomLeftImageView.widthAnchor.constraint(equalToConstant: 25),
            bottomLeftImageView.heightAnchor.constraint(equalToConstant: 25)
        ])

        addSubview(bottomRightImageView)
        NSLayoutConstraint.activate([
            bottomRightImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomRightImageView.rightAnchor.constraint(equalTo: rightAnchor),
            bottomRightImageView.widthAnchor.constraint(equalToConstant: 25),
            bottomRightImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
