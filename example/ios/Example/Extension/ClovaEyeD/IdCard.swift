/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreGraphics
import Foundation

import ClovaEyeD

extension NcpEkycApiManager.Document {

    func convert(dict: [String: [Result.BaseObject]]?,
                 infos: inout [TextInfo]) {
        dict?.forEach{ (field) in
            if let value = field.value.first {
                infos.append(TextInfo(title: field.key,
                                      description: value.text,
                                      textColor: .white))
            } else {
                infos.append(TextInfo(title: field.key,
                                      description: nil,
                                      textColor: AssetColor.clovaRed.uiColor))
            }
        }
    }

    func convert(dict: [String: [Result.BaseObject]]?,
                 boundingBoxes: inout [[CGPoint]]) {
        dict?.forEach { (result) in
            result.value.forEach { (object) in
                var boxes: [[CGPoint]] = []
                object.boundingPolys.forEach { (poly) in
                    let points = poly.vertices.map { CGPoint(x: $0.x, y: $0.y) }
                    boxes.append(points)
                }

                boundingBoxes += boxes
            }
        }
    }

    var textInfo: [TextInfo] {
        var infos: [TextInfo] = []
        convert(dict: result.ac, infos: &infos)
        convert(dict: result.dl, infos: &infos)
        convert(dict: result.ic, infos: &infos)
        convert(dict: result.pp, infos: &infos)
        infos.sort(by: { $0.title.lowercased() < $01.title.lowercased() })
        return infos
    }

    var boundingBoxes: [[CGPoint]] {
        var boundingBoxes: [[CGPoint]] = []
        convert(dict: result.ac, boundingBoxes: &boundingBoxes)
        convert(dict: result.dl, boundingBoxes: &boundingBoxes)
        convert(dict: result.ic, boundingBoxes: &boundingBoxes)
        convert(dict: result.pp, boundingBoxes: &boundingBoxes)
        return boundingBoxes
    }
}
