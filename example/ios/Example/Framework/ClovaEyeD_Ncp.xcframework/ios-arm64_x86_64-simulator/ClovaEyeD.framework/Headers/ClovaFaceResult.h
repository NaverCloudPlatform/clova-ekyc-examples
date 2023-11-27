/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief The pose of face.
typedef NS_ENUM(NSUInteger, ClovaFacePose) {
    /// @brief Unknown face pose.
    ClovaFacePoseUnknown,
    /// @brief The face looks straight ahead.
    ClovaFacePoseFront,
    /// @brief The face looks up.
    ClovaFacePoseUp,
    /// @brief The face looks down.
    ClovaFacePoseDown,
    /// @brief The face is tilted to the right.
    ClovaFacePoseRollRight,
    /// @brief The face is tilted to the left.
    ClovaFacePoseRollLeft,
    /// @brief The face looks to the right.
    ClovaFacePosePanRight,
    /// @brief The face looks to the left.
    ClovaFacePosePanLeft
};

/// @brief The status of the part of the face that can be opened.
typedef NS_ENUM(NSUInteger, ClovaOpenablePartState) {
    /// @brief Unknown state.
    ClovaOpenablePartStateUnknown,
    /// @brief Opened state.
    ClovaOpenablePartStateOpen,
    /// @brief Half Opened state.
    ClovaOpenablePartStateHalfOpen,
    /// @brief Closed state.
    ClovaOpenablePartStateClose
};

/// @brief Information on the face part that can be opened.
@interface ClovaFaceOpenablePart: NSObject

/// @brief The ratio of the part of the face that can be opened.
@property (nonatomic, readonly, assign) float ratio;
/// @brief The status of the part of the face that can be opened.
@property (nonatomic, readonly, assign) ClovaOpenablePartState state;

@end

/// @brief The 3D rotation matrix of a face in euler angles.
@interface ClovaFaceEulerAngle: NSObject

/// @brief The pitch value in between -90° and 90°.
@property (nonatomic, readonly, assign) float pitch;
/// @brief The roll value in between -90° and 90°.
@property (nonatomic, readonly, assign) float roll;
/// @brief The yaw value in between -90° and 90°.
@property (nonatomic, readonly, assign) float yaw;

@end

/// @brief The information about facial occlusion.
@interface ClovaOcclusions: NSObject

/// @brief Information that whether left eye landmark is hidden.
@property (nonatomic, readonly, assign) bool leftEyeOccluded;
/// @brief Information that whether right eye landmark is hidden.
@property (nonatomic, readonly, assign) bool rightEyeOccluded;
/// @brief Information that whether nose landmark is hidden.
@property (nonatomic, readonly, assign) bool noseOccluded;
/// @brief Information that whether mouth landmark is hidden.
@property (nonatomic, readonly, assign) bool mouthOccluded;

@end

/// @brief The information on facial spoofing.
@interface ClovaSpoof: NSObject

/// @brief Whether the face image is RGB spoofed or not.
@property (nonatomic, readonly, assign) bool isSpoofed;
/// @brief RGB Spoofing score value.
@property (nonatomic, readonly, assign) float spoofingScore;

@end

/// @brief The information on facial motion.
@interface ClovaMotions: NSObject

/// @brief Whether eyes have been blinked.
@property (nonatomic, readonly, assign) bool eyeBlink;
/// @brief Whether mouth has been opened.
@property (nonatomic, readonly, assign) bool mouthOpen;
/// @brief Whether head has been nodded.
@property (nonatomic, readonly, assign) bool headNod;
/// @brief Whether head has been rolled.
@property (nonatomic, readonly, assign) bool headRoll;
/// @brief Whether head has been shaken.
@property (nonatomic, readonly, assign) bool headShake;

@end

/// @brief The information on one of the faces inferenced.
@interface ClovaFace: NSObject

/// @brief An unique ID for the face.
@property (nonatomic, readonly, assign) int trackingId;
/// @brief The bounding box representing the face area.
@property (nonatomic, readonly, assign) CGRect boundingBox;
/// @brief 2D vertices representing the contours of the face.
@property (nonatomic, readonly, strong) NSArray<NSValue*>* contours;
/// @brief The visibility of each contour point ranging from `0` to `1.0`.
@property (nonatomic, readonly, strong) NSArray<NSNumber*>* visibility;
/// @brief The features of this face.
@property (nonatomic, readonly, strong, nullable) NSArray<NSNumber*>* recognizedFeature;
/// @brief The 3D rotation matrix of a face in Euler angles.
@property (nonatomic, readonly, strong) ClovaFaceEulerAngle* eulerAngle;
/// @brief The pose of face object.
@property (nonatomic, readonly, assign) ClovaFacePose pose;
/// @brief Left eye details.
@property (nonatomic, readonly, strong) ClovaFaceOpenablePart* leftEye;
/// @brief Right eye details.
@property (nonatomic, readonly, strong) ClovaFaceOpenablePart* rightEye;
/// @brief Mouth details.
@property (nonatomic, readonly, strong) ClovaFaceOpenablePart* mouth;
/// @brief The information about facial occlusion.
@property (nonatomic, readonly, strong) ClovaOcclusions* occlusions;
/// @brief The information on facial spoofing.
@property (nonatomic, readonly, strong) ClovaSpoof* spoof;
/// @brief The information on facial motion.
@property (nonatomic, readonly, strong) ClovaMotions* motions;
/// @brief Whether a mask is detected on a face.
@property (nonatomic, readonly, assign) bool maskDetected;

@end

/// @brief The measured data per pipeline stage
@interface ClovaFaceMeasure: NSObject

/// @brief The pipeline stage name.
@property (nonatomic, readonly, strong) NSString* key;
/// @brief The time spent on stage.
@property (nonatomic, readonly, assign) NSTimeInterval value;

@end

/// @brief The result of inferencing faces using detectFace function.
@interface ClovaFaceResult: NSObject

/// @brief A vector of one or more faces inferenced.
@property (nonatomic, readonly, strong) NSArray<ClovaFace*>* faces;
/// @brief A list of measured data per pipeline stage.
@property (nonatomic, readonly, strong) NSArray<ClovaFaceMeasure*>* measures;

@end

NS_ASSUME_NONNULL_END
