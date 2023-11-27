/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

enum HomeScenario: String, CaseIterable {
    case ekyc = "eKYC Sceanrio"

    static var values: [HomeScenario] {
        return [.ekyc]
    }
}
