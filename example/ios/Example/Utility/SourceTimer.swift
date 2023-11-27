/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

final class SourceTimer {

    private var timeoutInterval: TimeInterval?
    private let timer = Atomic<DispatchSourceTimer?> (nil)
    private let timerQueue = DispatchQueue.global(qos: .userInteractive)
}

extension SourceTimer {

    func stop() {
        timer.value?.cancel()
        timer.mutate({ $0 = nil })
    }

    func start(timeoutInterval: TimeInterval, timeoutBlock: @escaping () -> Void) {
        stop()
        let newTimer = DispatchSource.makeTimerSource(flags: .strict, queue: timerQueue)
        timer.mutate({ $0 = newTimer })
        newTimer.schedule(deadline: .now() + timeoutInterval, repeating: 0)
        newTimer.setEventHandler(handler: { [weak self] in
            self?.stop()
            timeoutBlock()
        })

        newTimer.resume()
    }
}
