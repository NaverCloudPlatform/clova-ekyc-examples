# Detecting face using CLOVA face detector

## Setting options

 `ClovaFaceDetector` is based on  CLOVAEyes SDK.
To create a `ClovaFaceDetector` instance, you need to set `ClovaFaceDetectorOption`.  
With the options, you can automatically configure the `CLOVA Eyes` pipeline, which is necessary to implement the required features (e.g. face detection, landmark point detection, etc.) for the eKYC service.<br>


## Creating instance

 You can configure options and create an instance as the following:

```swift
let faceOption  = ClovaFaceDetectorOption()
faceOption.stages.append(ClovaPipelineStage(stageType: .detector, filePath: path))
faceOption.stages.append(ClovaPipelineStage(stageType: .landmarker, filePath: path))
faceOption.stages.append(ClovaPipelineStage(stageType: .aligner, filePath: nil))
faceOption.stages.append(ClovaPipelineStage(stageType: .recognizer, filePath: path))
faceOption.stages.append(ClovaPipelineStage(stageType: .maskDetector, filePath: path))
faceDetector = ClovaFaceDetector(option: faceOption)
```

## Detecting face

The face detection feature of the CLOVA face detector SDK detects multiple faces within an image and returns them in `ClovaFaceResult` format.  
To perform face detection, you must create a `ClovaFaceDetector` instance and call its `detectFace()` function.  
If you wish to check the return format of `FaceResult` or various information about the detected faces, kindly refer to [Processing various information about the face](./info_iOS.md).

```swift
let faceResult = faceDetector.detectFace(with image)
```
