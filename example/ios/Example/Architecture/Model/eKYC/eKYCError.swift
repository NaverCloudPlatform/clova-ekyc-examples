/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

enum eKYCError {
    case rgbSpoof(prediction: Double)
    case failToCheckIDCard(similarity: Double, spoofPrediction: Double?)
    case serverError(message: String?)
}
