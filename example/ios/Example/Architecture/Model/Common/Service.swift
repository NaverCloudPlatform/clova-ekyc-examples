/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

struct Service {
    static var dict: NSDictionary? {
        if let path = Bundle.main.path(forResource: "Key", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        } else {
            return nil
        }
    }

    static var idCardInvokeUrl = Service.defaultIdCardInvokeUrl
    static var idCardSecretKey = Service.defaultIdCardSecretKey
    static var faceInvokeUrl = Service.defaultFaceInvokeUrl
    static var faceSecretKey = Service.defaultFaceSecretKey

    static var hasFaceDomainInfo: Bool {
        return !(faceInvokeUrl.isEmpty) && !(faceSecretKey.isEmpty)
    }

    private static var defaultIdCardInvokeUrl: String {
        return dict?.value(forKey: "ID_CARD_INVOKE_URL") as? String ?? ""
    }

    private static var defaultIdCardSecretKey: String {
        return dict?.value(forKey: "ID_CARD_SECRET_KEY") as? String ?? ""
    }

    private static var defaultFaceInvokeUrl: String {
        return dict?.value(forKey: "FACE_INVOKE_URL") as? String ?? ""
    }

    private static var defaultFaceSecretKey: String {
        return dict?.value(forKey: "FACE_SECRET_KEY") as? String ?? ""
    }
}
