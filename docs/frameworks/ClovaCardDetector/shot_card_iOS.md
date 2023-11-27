# Using the best card detection results

## Configuring the detection options

The CLOVA card detector offer to return the clearest card results among multiple frames. <br>The accumulative number of frames can be set through `ClovaCardDetectorOption.accumulatedFrameCount`

```swift
let cardDetector = ClovaCardDetector()
let cardDetectorOption = ClovaCardDetectorOption()
cardDetectorOption.accumulatedFrameCount = 10
cardDetector.setOption(cardDetectorOption)
```

## Detecting card and getting a best shot

If you need the clearest results as well as the real-time detection results, you can obtain them through  `shotCard()`.<br>
`shotCard()` returns the clearest result if detection is successful for more than `threshold`

```swift
func ClovaCardDetector.shotCard(threshold: Int)-> ClovaCardShotResult
```

```swift
let cardResult = cardDetector.detectCard(with: ClovaVisionImage)

if needBestShot {
  let cardShotResult = cardDetector.shotCard(threshold: 3)
  print(cardShotResult.status)
}
```

## Card shot results

The `ClovaCardShotResult` object returned from the `shotCard()` function consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `status` | `ClovaCardShotStatus` | Enum class for detection results |
| `ClovaCardShotStatus.notAvailable` |  |  |
| `ClovaCardShotStatus.available` |  |  |
| `card` | `ClovaCardShot` | Class containing the clearest detection results |
| `ClovaCardShot.rectInfo` | `ClovaCardRectInfo` | Class containing bounding box and angle information for the detected card |
| `ClovaCardShot.originImage` | `ClovaVisionImage` | Original card image |
