# Using the best id card detection results

## Configuring the detection options

The CLOVA card detector offer to return the clearest card results among multiple frames. The accumulative number of frames can be set through `ClovaIdCardDetectorOption.accumulatedFrameCount`

```kotlin
val idCardDetector = ClovaIdCardDetector(option: ClovaFaceDetectorOption)
val idCardDetectorOption = ClovaIdCardDetectorOption(accumulatedFrameCount = 10)

idCardDetector.setOption(idCardDetectorOption)

```

## Detecting id card and getting a best shot

If you need the clearest results as well as the real-time detection results, you can obtain them through  `shotIdCard()`.
`shotIdCard()` returns the clearest result if detection is successful for more than `threshold`

```kotlin
fun ClovaIdCardDetector.shotIdCard(threshold: Int): ClovaIdCardShotResult

enum class ClovaIdCardShotStatus(val value: Int) {
    AVAILABLE(value = 0),
    NOT_AVAILABLE(value = 1),
    BLUR_ERROR(value = 2),
    GLARE_ERROR(value = 3),
    DARK_ERROR(value = 4)
}

data class ClovaIdCardShot(
    val rectInfo: ClovaCardRectInfo,
    val originImage: ClovaVisionImage
)

data class ClovaIdCardShotResult(
    val status: ClovaIdCardShotStatus = ClovaIdCardShotStatus.NOT_AVAILABLE,
    val idCard: ClovaIdCardShot? = null
)
```

```kotlin
val idCardResult = idCardDetector.detectIdCard(image: ClovaVisionImage)

if(needBestShot){
  val idCardShotResult = idCardDetector.shotIdCard(threshold = 3)
  
  when(idCardShotResult.status){
     ClovaIdCardShotStatus.NOT_AVAILABLE -> toast("fail")
     ClovaIdCardShotStatus.AVAILABLE -> showResult(idCardShotResult.originImage)
  }
}
```

## Id card shot results

The `ClovaIdCardShotResult` object returned from the `shotIdCard()` function consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `status` | `ClovaIdCardShotStatus` | Enum class for detection results |
| `ClovaIdCardShotStatus.NOT_AVAILABLE` |  |  |
| `ClovaIdCardShotStatus.BLUR_ERROR` |  |  |
| `ClovaIdCardShotStatus.GLARE_ERROR` |  |  |
| `ClovaIdCardShotStatus.DARK_ERROR` |  |  |
| `ClovaIdCardShotStatus.AVAILABLE` |  |  |
| `idCard` | `ClovaIdCardShot` | Class containing the clearest detection results |
| `ClovaCardShot.rectInfo` | `ClovaCardRectInfo` | Class containing bounding box and angle information for the detected card |
| `ClovaCardShot.faceInfo` | `ClovaIdCardFaceInfo` | Class containing face information |
| `ClovaCardShot.originImage` | `ClovaVisionImage` | The image of detected card |

