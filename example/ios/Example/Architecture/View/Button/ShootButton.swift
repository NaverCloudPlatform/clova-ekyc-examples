/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class ShootButton: UIButton {

    init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.3
        }
    }
}

extension ShootButton {

    private func configureLayout() {
        backgroundColor = AssetColor.gray3.uiColor
        makeRoundBorder(radius: 3)
        setTitle("Shoot", for: .normal)
        tintColor = .white
        titleLabel?.font = .systemFont(ofSize: 15, weight: 700)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        setImage(AssetImage.icon_camera.uiImage, for: .normal)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 54)
        ])
    }
}
