/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

import Lottie

final class ProcessingView: UIView {

    var isProcessing = false

    private let animationView: AnimationView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.animation = Animation.named("EyeD_loading")
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        return $0
    }(AnimationView())

    init() {
        super.init(frame: .zero)
        configureLayout()
        stop()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProcessingView {

    func play() {
        let item = DispatchWorkItem(block: { [weak self] in
            self?.isHidden = false
            self?.animationView.play()
            self?.isProcessing = true
        })

        performOnMainThread(item: item)
    }

    func stop() {
        let item = DispatchWorkItem(block: { [weak self] in
            self?.isHidden = true
            self?.animationView.stop()
            self?.isProcessing = false
        })

        performOnMainThread(item: item)
    }
}

extension ProcessingView {

    private func configureLayout() {
        backgroundColor = .black.withAlphaComponent(0.5)
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 60),
            animationView.heightAnchor.constraint(equalToConstant: 60),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 120)
        ])
    }

    private func performOnMainThread(item: DispatchWorkItem) {
        if Thread.isMainThread {
            item.perform()
        } else {
            DispatchQueue.main.async(execute: item)
        }
    }
}
