/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class RadioButtonView: UIView {

    var borderColor: UIColor? = AssetColor.gray2.uiColor

    private let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaBlue.uiColor
        return $0
    }(UIView())

    private let circleView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.makeRoundBorder(radius: 4.28)
        return $0
    }(UIView())

    init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isSelected: Bool = false {
        didSet {
            if isSelected {
                layer.borderWidth = .zero
                contentView.isHidden = false
            } else {
                layer.borderWidth = 1.5
                layer.borderColor = borderColor?.cgColor
                contentView.isHidden = true
            }
        }
    }
}

extension RadioButtonView {

    private func configureLayout() {
        backgroundColor = .clear
        makeRoundBorder(radius: 11)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 22),
            widthAnchor.constraint(equalToConstant: 22),
        ])

        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
        ])

        contentView.addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.heightAnchor.constraint(equalToConstant: 8.56),
            circleView.widthAnchor.constraint(equalToConstant: 8.56),
        ])

        isSelected = false
    }
}
