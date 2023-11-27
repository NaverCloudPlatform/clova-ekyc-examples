/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

extension Bundle {

    static var appVersion: String {
        let versionStringKey = "CFBundleShortVersionString"
        return main.object(forInfoDictionaryKey: versionStringKey) as? String ?? ""
    }
}
