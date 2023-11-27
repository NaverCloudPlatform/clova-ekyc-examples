# Comparing faces using CLOVA face detector

CLOVA face detector allows for comparison of the similarity of different faces. This comparison can be utilized in features such as comparing the face on a government-issued ID with the face captured in real-time from a camera during the eKYC process.

## Comparing faces in mobile environment

Clova Face Detector supports face-to-face similarity comparison.

```kotlin
fun ClovaFaceDetector.getSimilarity(face1: ClovaFace, face2: ClovaFace): Float
```

To compare faces, aligner, recognizer stage must be enabled.

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

You can get similarities with  `ClovaFace`, which is the result of  `detectFace()` .

```kotlin
val clovaFaceResult = faceDetector.detectFace(imageWithTwoPeople)

val face1 = clovaFaceResult.faces.getOrNull(0)
val face2 = clovaFaceResult.faces.getOrNull(1)

val similarity = ClovaFaceDetector.getSimilarity(face1, face2)
```

> **Note**
> If you do not enable aligner, recognizer stage in `ClovaFaceDetectorOption`, an incorrect similarity value may be returned.

