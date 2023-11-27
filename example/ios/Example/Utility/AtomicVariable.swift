/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

final class Atomic<A> {

    private let queue = DispatchQueue(label: "AtomicQueue", attributes: .concurrent)
    private var _value: A

    init(_ value: A) {
        self._value = value
    }

    var value: A {
        get { return queue.sync { self._value } }
    }

    func mutate(_ transform: (inout A) -> ()) {
        queue.sync(flags: .barrier) { transform(&self._value) }
    }
}
