# Comparing faces using CLOVA face detector

CLOVA face detector allows for comparison of the similarity of different faces. This comparison can be utilized in features such as comparing the face on a government-issued ID with the face captured in real-time from a camera during the eKYC process.

## Comparing faces in mobile environment

Clova Face Detector supports face-to-face similarity comparison.

```swift
func ClovaFaceDetector.getSimilarity(ClovaFace, ClovaFace): Float
```

To compare faces, aligner, recognizer stage must be enabled.

```swift
let faceOption  = ClovaFaceDetectorOption()
faceOption.stages.append(ClovaPipelineStage(stageType: .detector, filePath: path))
faceOption.stages.append(ClovaPipelineStage(stageType: .landmarker, filePath: path))
faceOption.stages.append(ClovaPipelineStage(stageType: .aligner, filePath: nil))
faceOption.stages.append(ClovaPipelineStage(stageType: .recognizer, filePath: path))
faceOption.stages.append(ClovaPipelineStage(stageType: .maskDetector, filePath: path))
faceDetector = ClovaFaceDetector(option: faceOption)
```

You can get similarities with  `ClovaFace`, which is the result of  `detectFace()` .

```swift
let clovaFaceResult = faceDetector.detectFace(with: image)
let face1 = clovaFaceResult.faces[0]
let face2 = clovaFaceResult.faces[1]
let similarity = ClovaFaceDetector.getSimilarity(face1, face2)
```

> **Note**
> If you do not enable aligner, recognizer stage in `ClovaFaceDetectorOption`, an incorrect similarity value may be returned.

