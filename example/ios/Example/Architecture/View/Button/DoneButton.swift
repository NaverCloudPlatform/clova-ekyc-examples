/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class DoneButton: UIButton {

    init() {
        super.init(frame: .zero)
        configureLayout()
        isEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                tintColor = .white
                backgroundColor = AssetColor.clovaGreen.uiColor
            } else {
                tintColor = .white.withAlphaComponent(0.5)
                backgroundColor = AssetColor.gray9.uiColor
            }
        }
    }
}

extension DoneButton {

    private func configureLayout() {
        makeRoundBorder(radius: 3)
        setTitle("Done", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 15, weight: 700)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 54)
        ])
    }
}
