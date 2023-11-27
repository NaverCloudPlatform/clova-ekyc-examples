# Detecting face using CLOVA face detector

## Setting options

 `ClovaFaceDetector` is based on  CLOVAEyes SDK.
To create a `ClovaFaceDetector` instance, you need to set `ClovaFaceDetectorOption`.  
With the options, you can automatically configure the `CLOVA Eyes` pipeline, which is necessary to implement the required features (e.g. face detection, landmark point detection, etc.) for the eKYC service.</br>
Details of the options  as the following: 

```kotlin
data class ClovaFaceDetectorOption (
    var numberOfThreads: Int = -1, // mumber of threads to use for inference
    var enableMeasure: Boolean = false,  // processing time return or not
    var motionFrameInterval: Int = 2, // frame interval to use when detecting motion
    var stageTypes: StageTypes = StageTypes(),
    var detectorOption: DetectorOption = DetectorOption(), // detail options about detector stage
    var landmarkOption: LandmarkOption = LandmarkOption(), // detail options about landmaker stage
    var spoofingOption: SpoofingOption = SpoofingOption(), // detail options about spoofing stage
    var faceThreshold: FaceThreshold = FaceThreshold() // threshold for determining face pose information
) {
    data class Stage(
        var isEnabled: Boolean = false, // Whether to enable the stage type.
        var data: ByteArray? = null, // The data of model.
    ) {
        // You can use a model path or an asset's model path
        constructor(isEnabled: Boolean, modelFilePath: String)
                : this(isEnabled, FileInputStream(File(modelFilePath)).let { inputStream ->
            ByteArray(size = inputStream.available()).apply {
                inputStream.read(this)
            }
        })

        constructor(isEnabled: Boolean, context: Context, modelFilePathFromAsset: String)
                : this(isEnabled, context.assets.open(modelFilePathFromAsset).let { inputStream ->
            ByteArray(size = inputStream.available()).apply {
                inputStream.read(this)
            }
        })
    }
    
    data class StageTypes(
        var detector: Stage = Stage(),
        var landmarker: Stage = Stage(),
        var aligner: Stage = Stage(),
        var maskDetector: Stage = Stage(),
        var spoofingDetector: Stage = Stage(),
        var recognizer: Stage = Stage(),
        var occlusion: Stage = Stage()
    )

    data class DetectorOption(
        var useFilter: Boolean = true,
        var boundingBoxThrehold: Float = 0.7f
    )


    data class LandmarkOption(
        var eyeBlinkDetect: Boolean = false,
        var support240Contour: Boolean = false,
        var useFilter: Boolean = true,
        var adjustBoundingBox: Boolean = true
    )


    data class SpoofingOption(
        var spoofPadRatio: Float = 0.5f,
        var spoofThreshold: Float = 0.1f,
    )
  
    data class FaceThreshold(
        var eyeOpenThreshold: Float = 0.15f,
        var eyeCloseThreshold: Float = 0.1f,
        var mouthOpenThreshold: Float = 0.3f,
        var mouthCloseThreshold: Float = 0.1f,
        var visibilityThreshold: Float = 0.4f,
        var pitchThreshold: Float = 18.0f,
        var rollThreshold: Float = 12.0f,
        var yawThreshold: Float = 20.0f,
    )
}
```

## Creating instance

 You can configure options and create an instance as the following:

```kotlin
val options = ClovaFaceDetectorOption(
    stageTypes = ClovaFaceDetectorOption.StageTypes(
        detector = ClovaFaceDetectorOption.Stage(
            isEnabled = true,
            context = requireContext(),
            modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesDetector.value
        ),
        landmarker = ClovaFaceDetectorOption.Stage(
            isEnabled = true,
            context = requireContext(),
            modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesLandmarker.value
        ),
        aligner = ClovaFaceDetectorOption.Stage(
            isEnabled = true
        ),
        recognizer = ClovaFaceDetectorOption.Stage(
            isEnabled = true,
            context = requireContext(),
            modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesRecognizer.value
        )
    )
)

val faceDetector = ClovaFaceDetector(options)
```

## Detecting face

The face detection feature of the CLOVA face detector SDK detects multiple faces within an image and returns them in `ClovaFaceResult` format.  
To perform face detection, you must create a `ClovaFaceDetector` instance and call its `detectFace()` function.  
If you wish to check the return format of `FaceResult` or various information about the detected faces, kindly refer to [Processing various information about the face](./info_AOS.md).

```kotlin
val faceResult = faceDetector.detectFace(image)
faceResult.faces.filter {
  drawRect(it.boundingBox)
}
```