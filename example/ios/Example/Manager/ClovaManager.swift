/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

import ClovaEyeD

final class ClovaManager {

    static let shared = ClovaManager()

    let faceDetector: ClovaFaceDetector
    let cardDetector = ClovaCardDetector()
    let idCardDetector: ClovaIdCardDetector

    private init() {
        let faceOption  = ClovaFaceDetectorOption()
        faceOption.stages.append(ClovaPipelineStage(stageType: .detector, filePath: TFLiteModel.detector.modelPath))
        faceOption.stages.append(ClovaPipelineStage(stageType: .landmarker, filePath: TFLiteModel.landmarker.modelPath))
        faceOption.stages.append(ClovaPipelineStage(stageType: .aligner, filePath: nil))
        faceOption.stages.append(ClovaPipelineStage(stageType: .recognizer, filePath: TFLiteModel.recognizer.modelPath))
        faceOption.stages.append(ClovaPipelineStage(stageType: .maskDetector, filePath: TFLiteModel.maskDetector.modelPath))
        faceDetector = ClovaFaceDetector(option: faceOption)
        idCardDetector = ClovaIdCardDetector(option: faceOption)
    }
}

extension ClovaManager {

    private var apiManager: NcpEkycApiManager {
        let option = NcpEkycApiManager.Option(idCardInvokeUrl: Service.idCardInvokeUrl,
                                              idCardSecretKey: Service.idCardSecretKey,
                                              faceInvokeUrl: Service.faceInvokeUrl,
                                              faceSecretKey: Service.faceSecretKey)
        return NcpEkycApiManager(option: option)
    }

    func document(with image: UIImage,
             completion: @escaping (Result<NcpEkycApiManager.Document, NcpEkycApiManager.ApiError>) -> Void) {
        apiManager.document(image: image, completion: { (result) in
            completion(result)
        })
    }

    func verify(with document: NcpEkycApiManager.Document,
                completion: @escaping (Result<NcpEkycApiManager.VerifyResult, NcpEkycApiManager.ApiError>) -> Void) {
        apiManager.verify(document: document, completion: { (result) in
            completion(result)
        })
    }

    func compare(face1: UIImage, face2: UIImage,
                 completion: @escaping (Result<NcpEkycApiManager.CompareResult, NcpEkycApiManager.ApiError>) -> Void) {
        apiManager.compare(face1: face1, face2: face2, completion: { (result) in
            completion(result)
        })
    }
}
