/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class TimerView: UIView {

    private let currentValue = Atomic<Int> (3)
    private let timerQueue = DispatchQueue.global(qos: .userInteractive)
    private let timer = Atomic<DispatchSourceTimer?> (nil)
    private var handler: (() -> Void)?

    private let numLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 78, weight: .regular)
        return $0
    }(UILabel())

    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimerView {

    func countDown(completion: @escaping (() -> Void)) {
        handler = completion
        numLabel.text = currentValue.value.description
        numLabel.isHidden = false
        startTimer()
    }

    func cancel() {
        stopTimer()
        currentValue.mutate({ $0 = 3 })
        handler = nil
        numLabel.isHidden = true
    }
}

extension TimerView {

    private func configureLayout() {
        backgroundColor = .clear
        addSubview(numLabel)
        numLabel.isHidden = true
        NSLayoutConstraint.activate([
            numLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numLabel.widthAnchor.constraint(equalToConstant: 47),
            numLabel.heightAnchor.constraint(equalToConstant: 93),
        ])
    }

    private func startTimer() {
        stopTimer()
        let newTimer = DispatchSource.makeTimerSource(flags: .strict, queue: timerQueue)
        timer.mutate({ $0 = newTimer })
        newTimer.schedule(deadline: .now() + 1, repeating: 0)
        newTimer.setEventHandler(handler: { [weak self] in
            self?.didReceiveTimeout()
        })

        newTimer.resume()
    }

    private func stopTimer() {
        timer.value?.cancel()
        timer.mutate({ $0 = nil })
    }

    private func didReceiveTimeout() {
        stopTimer()
        let newValue = currentValue.value - 1
        DispatchQueue.main.async { [weak self] in
            if newValue > 0 {
                self?.currentValue.mutate({ $0 = newValue })
                self?.numLabel.text = newValue.description
                self?.startTimer()
            } else {
                self?.handler?()
                self?.cancel()
            }
        }
    }
}
