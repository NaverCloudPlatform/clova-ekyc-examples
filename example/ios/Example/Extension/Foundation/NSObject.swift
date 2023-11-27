/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

extension NSObject {

    class var className: String {
        String(describing: self)
    }
}
