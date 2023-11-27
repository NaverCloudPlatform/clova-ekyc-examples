/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

extension Array {

    subscript (safe index: Array.Index) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let element = newValue else { return }
            self[index] = element
        }
    }
}
