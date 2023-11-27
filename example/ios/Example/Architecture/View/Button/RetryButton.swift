/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class RetryButton: UIButton {

    init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RetryButton {

    private func configureLayout() {
        tintColor = .white
        titleLabel?.font = .systemFont(ofSize: 15, weight: 600)
        setTitle("Retry", for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        setImage(AssetImage.icon_retry.uiImage, for: .normal)
    }
}
