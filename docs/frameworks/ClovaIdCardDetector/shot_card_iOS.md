# Using the best id card detection results

## Configuring the detection options

The CLOVA card detector offer to return the clearest card results among multiple frames. The accumulative number of frames can be set through `ClovaIdCardDetectorOption.accumulatedFrameCount`

```swift
let idCardDetector = ClovaIdCardDetector(option: ClovaFaceDetectorOption)
let idCardDetectorOption = ClovaIdCardDetectorOption()
idCardDetectorOption.accumulatedFrameCount = 10
idCardDetector.setOption(idCardDetectorOption)
```

## Detecting id card and getting a best shot

If you need the clearest results as well as the real-time detection results, you can obtain them through  `shotIdCard()`.
`shotIdCard()` returns the clearest result if detection is successful for more than `threshold`

```swift
func ClovaIdCardDetector.shotIdCard(threshold: Int)-> ClovaIdCardShotResult
```

```swift
let idCardResult = idCardDetector.detectIdCard(with: ClovaVisionImage)

if needBestShot {
  let idCardShotResult = idCardDetector.shotIdCard(threshold: 3)
  print(idCardShotResult.status)
}
```

## Id card shot results

The `ClovaIdCardShotResult` object returned from the `shotIdCard()` function consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `status` | `ClovaIdCardShotStatus` | Enum class for detection results |
| `ClovaIdCardShotStatus.notAvailable` |  |  |
| `ClovaIdCardShotStatus.blurError` |  |  |
| `ClovaIdCardShotStatus.glareError` |  |  |
| `ClovaIdCardShotStatus.darkError` |  |  |
| `ClovaIdCardShotStatus.available` |  |  |
| `idCard` | `ClovaIdCardShot` | Class containing the clearest detection results |
| `ClovaCardShot.rectInfo` | `ClovaCardRectInfo` | Class containing bounding box and angle information for the detected card |
| `ClovaCardShot.faceInfo` | `ClovaIdCardFaceInfo` | Class containing face information |
| `ClovaCardShot.originImage` | `ClovaVisionImage` | The image of detected card |

