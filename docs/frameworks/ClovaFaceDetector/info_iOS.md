# Utilizing face information with CLOVA face detector

## Face detection results

The `ClovaFaceResult` object returned from the `ClovaFaceDetector.detectFace()` function consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `faces` | `Array<ClovaFace>` | List of detected face information|
| `measures` | `Array<ClovaFaceMeasure>`| List of measurement results for each stage|

## `ClovaFace`

`ClovaFace` object contains various face information, including the location of the detected face and feature points.<br>consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `boundingBox`                      | `CGRect`                   | Rectangle information representing the face zone             |
| `trackingID`                       | `Int`                    | ID to identify faces                                         |
| `contours` | `Array<NSValue>` | 2D vertices representing the face outline|
| `visibility`                       | `Array<NSNumber>`           | Whether each vertex representing the face outline is obscured or not |
| `recognizedFeature`                | `Array<NSNumber>?`           | Feature information about detected face, is used to score similarity |
| `eulerAngle`                       | `ClovaFaceEulerAngle`        | Roll, pitch, yaw information about detected face             |
| `ClovaFaceEulerAngle.roll`             | `Int`                    |                                                              |
| `ClovaFaceEulerAngle.pitch`            | `Int`                    |                                                              |
| `ClovaFaceEulerAngle.yaw`              | `Int`                    |                                                              |
| `pose`                             | `ClovaFacePose`              | Pose information about detected face                         |
| `ClovaFacePose.unknown`                | `enum`                   |                                                              |
| `ClovaFacePose.front`                  | `enum`                   |                                                              |
| `ClovaFacePose.up`                     | `enum`                   |                                                              |
| `ClovaFacePose.down`                   | `enum`                   |                                                              |
| `ClovaFacePose.rollRight`             | `enum`                   |                                                              |
| `ClovaFacePose.rollLeft`              | `enum`                   |                                                              |
| `ClovaFacePose.panRight`              | `enum`                   |                                                              |
| `ClovaFacePose.panLeft`               | `enum`                   |                                                              |
| `leftEye`                          | `ClovaFaceOpenablePart`  | Left eye information about detected face |
| `rightEye`                         | `ClovaFaceOpenablePart`  | Right eye information about detected face |
| `mouth`                            | `ClovaFaceOpenablePart`  | Mouth information about detected face |
| `ClovaFaceOpenablePart.ratio`      | `Float`                  |                                                              |
| `ClovaFaceOpenablePart.state`      | `ClovaFaceOpenablePartState` |                                                              |
| `ClovaFaceOpenablePartState.unknown`   | `enum`                   |                                                              |
| `ClovaFaceOpenablePartState.open`      | `enum`                   |                                                              |
| `ClovaFaceOpenablePartState.halfOpen` | `enum`                   |                                                              |
| `ClovaFaceOpenablePartState.close`     | `enum`                   |                                                              |
| `occlusions`                       | `ClovaOcclusion`         | Occlusion information for face part of the face |
| `ClovaOcclusion.leftEyeOccluded` | `Bool`                |    |
| `ClovaOcclusion.rightEyeOccluded` | `Bool`      |                                     |
| `ClovaOcclusion.noseOccluded` | `Bool`     |                        |
| `ClovaOcclusion.mouthOccluded` | `Bool` |  |
| `maskDetected` | `Bool` | Whether wearing a mask or not |
| `spoof` | `ClovaSpoof` | RGB spoofing information for detected face |
| `ClovaSpoof.isSpoof` | `Bool` | RGB spoofing result value |
| `ClovaSpoof.spoofScore` | `Float` | Detail RGB spoofing score |
| `motions` | `ClovaMotions` | Motion information about detected face |
| `ClovaMotions.eyeBlink` | `Bool` |  |
| `ClovaMotions.mouthOpen` | `Bool` |  |
| `ClovaMotions.headNod` | `Bool` |  |
| `ClovaMotions.headRoll` | `Bool` |  |
| `ClovaMotions.headShake` | `Bool` |  |

## `ClovaMeasure`

It contains `ClovaMeasure` `ClovaEyes` pipeline stage execution time information and consists of the following information:

| Items| Type| Description|
|:----------|:----------|----------|
| `key`| `String`| Name of the `ClovaEyes` stage|
| `value`| `TimeInterval`| Time spent by the stage, milliseconds|

