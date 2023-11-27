# Utilizing face information with CLOVA face detector

## Face detection results

The `ClovaFaceResult` object returned from the `ClovaFaceDetector.detectFace()` function consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `faces` | `List<ClovaFace>` | List of detected face information|
| `measures` | `List<ClovaMeasure>`| List of measurement results for each stage|

## `ClovaFace`

`ClovaFace` object contains various face information, including the location of the detected face and feature points.<br>consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `boundingBox`                      | `Rect`                   | Rectangle information representing the face zone             |
| `trackingID`                       | `int`                    | ID to identify faces                                         |
| `contours` | `List<PointF>` | 2D vertices representing the face outline|
| `visibility`                       | `List<Float>?`           | Whether each vertex representing the face outline is obscured or not |
| `recognizedFeature`                | `List<Float>?`           | Feature information about detected face, is used to score similarity |
| `eulerAngle`                       | `ClovaEulerAngle`        | Roll, pitch, yaw information about detected face             |
| `ClovaEulerAngle.roll`             | `int`                    |                                                              |
| `ClovaEulerAngle.pitch`            | `int`                    |                                                              |
| `ClovaEulerAngle.yaw`              | `int`                    |                                                              |
| `pose`                             | `ClovaPose`              | Pose information about detected face                         |
| `ClovaPose.UNKNOWN`                | `enum`                   |                                                              |
| `ClovaPose.FRONT`                  | `enum`                   |                                                              |
| `ClovaPose.UP`                     | `enum`                   |                                                              |
| `ClovaPose.DOWN`                   | `enum`                   |                                                              |
| `ClovaPose.ROLL_RIGHT`             | `enum`                   |                                                              |
| `ClovaPose.ROLL_LEFT`              | `enum`                   |                                                              |
| `ClovaPose.PAN_RIGHT`              | `enum`                   |                                                              |
| `ClovaPose.PAN_LEFT`               | `enum`                   |                                                              |
| `leftEye`                          | `ClovaFaceOpenablePart`  | Left eye information about detected face |
| `rightEye`                         | `ClovaFaceOpenablePart`  | Right eye information about detected face |
| `mouth`                            | `ClovaFaceOpenablePart`  | Mouth information about detected face |
| `ClovaFaceOpenablePart.ratio`      | `float`                  |                                                              |
| `ClovaFaceOpenablePart.state`      | `ClovaFaceOpenableState` |                                                              |
| `ClovaFaceOpenableState.UNKNOWN`   | `enum`                   |                                                              |
| `ClovaFaceOpenableState.OPEN`      | `enum`                   |                                                              |
| `ClovaFaceOpenableState.HALF_OPEN` | `enum`                   |                                                              |
| `ClovaFaceOpenableState.CLOSE`     | `enum`                   |                                                              |
| `occlusions`                       | `ClovaOcclusion`         | Occlusion information for face part of the face |
| `ClovaOcclusion.leftEyeOccluded` | `boolean`                |    |
| `ClovaOcclusion.rightEyeOccluded` | `boolean`      |                                     |
| `ClovaOcclusion.noseOccluded` | `boolean`     |                        |
| `ClovaOcclusion.mouthOccluded` | `boolean` |  |
| `maskDetected` | `boolean` | Whether wearing a mask or not |
| `spoof` | `ClovaSpoof` | RGB spoofing information for detected face |
| `ClovaSpoof.isSpoof` | `Boolean` | RGB spoofing result value |
| `ClovaSpoof.spoofScore` | `Float` | Detail RGB spoofing score |
| `motions` | `ClovaMotion` | Motion information about detected face |
| `ClovaMotion.eyeBlink` | `Boolean` |  |
| `ClovaMotion.mouthOpen` | `Boolean` |  |
| `ClovaMotion.headNod` | `Boolean` |  |
| `ClovaMotion.headRoll` | `Boolean` |  |
| `ClovaMotion.headShake` | `Boolean` |  |

## `ClovaMeasure`

It contains `ClovaMeasure` `ClovaEyes` pipeline stage execution time information and consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `stage`| `string`| Name of the `ClovaEyes` stage|
| `measureInMs`| `float`| Time spent by the stage, milliseconds|

