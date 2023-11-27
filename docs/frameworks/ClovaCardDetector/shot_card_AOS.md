# Using the best card detection results

## Configuring the detection options

The CLOVA card detector offer to return the clearest card results among multiple frames. <br>The accumulative number of frames can be set through `ClovaCardDetectorOption.accumulatedFrameCount`

```kotlin
val cardDetector = ClovaCardDetector()
val cardDetectorOption = ClovaCardDetectorOption(accumulatedFrameCount = 10)

cardDetector.setOption(cardDetectorOption)

```

## Detecting card and getting a best shot

If you need the clearest results as well as the real-time detection results, you can obtain them through  `shotCard()`.<br>
`shotCard()` returns the clearest result if detection is successful for more than `threshold`

```kotlin
fun ClovaCardDetector.shotCard(threshold: Int): ClovaCardShotResult

enum class ClovaCardShotStatus(val value: Int) {
    AVAILABLE(value = 0),
    NOT_AVAILABLE(value = 1)
}

data class ClovaCardShot(
    val rectInfo: ClovaCardRectInfo,
    val originImage: Bitmap
)

data class ClovaCardShotResult(
    val status: ClovaCardShotStatus = ClovaCardShotStatus.NOT_AVAILABLE,
    val card: ClovaCardShot? = null
)
```

```kotlin
val cardResult = cardDetector.detectCard(image: ClovaVisionImage)

if(needBestShot){
  val cardShotResult = cardDetector.shotCard(threshold = 3)
  
  when(cardShotResult.status){
     ClovaCardShotStatus.NOT_AVAILABLE -> toast("fail")
     ClovaCardShotStatus.AVAILABLE -> showResult(cardShotResult.originImage)
  }
}
```

## Card shot results

The `ClovaCardShotResult` object returned from the `shotCard()` function consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `status` | `ClovaCardShotStatus` | Enum class for detection results |
| `ClovaCardShotStatus.NOT_AVAILABLE` |  |  |
| `ClovaCardShotStatus.AVAILABLE` |  |  |
| `card` | `ClovaCardShot` | Class containing the clearest detection results |
| `ClovaCardShot.rectInfo` | `ClovaCardRectInfo` | Class containing bounding box and angle information for the detected card |
| `ClovaCardShot.originImage` | `ClovaVisionImage` | Original card image |
