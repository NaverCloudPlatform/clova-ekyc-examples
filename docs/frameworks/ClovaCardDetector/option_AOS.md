# Using various card detection options for better card detection

## Configuring the detection options

The CLOVA card detector SDK offers various options to detect clearer card images from the input images.  
You can use various options such as light reflection detection and camera shake detection as follows:

```kotlin
val option = DetectCardOption(
  cardRatio = 1.5858f,
  targetAngle = 90, 
  angleOffset = 5,
  minimumSize = 0.65f,
  checkSideDetected = true,
  checkCameraShaky = true,
  accumulatedFrameCount = 10
)
```

| Items| Type| Description|
|:----------|:----------|----------|
| `cardRatio`| float| Percentage of cards to detect|
| `targetAngle`| int| The angle of the card to be detected is calculated as follows:<br/>![Angle](../../images/calculate_angle.jpeg) |
| `angleOffset`| int| Angle offset<br/>[targetAngle - angleOffset <= detection angle <= targetAngle + angleOffset]|
| `minimumSize`| float| Minimum area of the card to be detected (detection card area / card ROI zone `cropRect`)|
| `checkSideDetected`| boolean| Whether to detect and return the card sides (top, bottom, left, right)|
| `checkCameraShaky`      | boolean | Whether to detect camera shake                               |
| `accumulatedFrameCount` | Int     | Number of frames to accumulate when using `shotCard()`       |

