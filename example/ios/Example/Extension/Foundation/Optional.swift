/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional {

    var isNil: Bool { self == nil }
}
