/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief The location of the face in id card.
typedef NS_ENUM(NSUInteger, ClovaIdFaceLocation) {
    /// @brief The face is somewhere in the id card.
    ClovaIdFaceLocationAnyWhere,
    /// @brief The face is on the left side of the id card.
    ClovaIdFaceLocationLeft,
    /// @brief The face is on the right side of the id card.
    ClovaIdFaceLocationRight,
    /// @brief No face on id card. (ex) back side of id card)
    ClovaIdFaceLocationNone
};

/// @brief The container for options of the ClovaIdCardDetector.
@interface ClovaIdCardDetectorOption: NSObject

/// @brief Target width height ratio of card to detect, default is 1.5858 [International Card Ratio (ID-1) (total card area) ROUND (85.60/53.98)]
@property (nonatomic, readwrite, assign) float cardRatio;
/// @brief Target angle of card to detect, default is 90.
@property (nonatomic, readwrite, assign) int targetAngle;
/// @brief Offset of angle to detect, default is 5. [targetAngle - angleOffset <= detect range <= targetAngle + angleOffset] The possible angle range is 70-110 degrees.
@property (nonatomic, readwrite, assign) int angleOffset;
/// @brief The minimum size of a bounding rectangle to detect, as a proportion of the smallest dimension.
@property (nonatomic, readwrite, assign) float minimumSize;
/// @brief Whether to detect each side line of the card.
@property (nonatomic, readwrite, assign) bool checkSideDetected;
/// @brief Whether to detect camera shaking.
@property (nonatomic, readwrite, assign) bool checkCameraShaky;
/// @brief Whether to detect blurry image.
@property (nonatomic, readwrite, assign) bool checkImageBlurry;
/// @brief Whether to detect dark image.
@property (nonatomic, readwrite, assign) bool checkImageDark;
/// @brief Whether to detect glare image.
@property (nonatomic, readwrite, assign) bool checkGlareDeteced;
/// @brief Blur judgment threshold.
@property (nonatomic, readwrite, assign) float blurThreshold;
/// @brief Dark judgment threshold.
@property (nonatomic, readwrite, assign) int darkThreshold;
/// @brief Indicates whether the camera is using HDR. Used to detect glare images.
@property (nonatomic, readwrite, assign) bool isHDREnabled;
/// @brief Indicates what percentage of the card area should be occupied by light reflection to determine as an error.
@property (nonatomic, readwrite, assign) float glarePercentage;
/// @brief The location of the face in id card.
@property (nonatomic, readwrite, assign) ClovaIdFaceLocation faceLocation;
/// @brief Total number of frames to be accumulated to determine the best id card shot.
@property (nonatomic, readwrite, assign) int accumulatedFrameCount;

/// @brief Intialize ClovaCardDetectorOption
-(id)init;

@end

NS_ASSUME_NONNULL_END
