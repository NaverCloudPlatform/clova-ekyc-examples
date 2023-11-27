/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class CameraClickAnimationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white.withAlphaComponent(0)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func click(completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.backgroundColor = .white.withAlphaComponent(0.7)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.backgroundColor = .white.withAlphaComponent(0)
            }, completion: { _ in
                completion()
            })
        })
    }
}
