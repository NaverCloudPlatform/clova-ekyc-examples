/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief The container for options of the ClovaCardDetector.
@interface ClovaCardDetectorOption: NSObject

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
/// @brief Total number of frames to be accumulated to determine the best card shot.
@property (nonatomic, readwrite, assign) int accumulatedFrameCount;
/// @brief Intialize ClovaCardDetectorOption
-(id)init;

@end

NS_ASSUME_NONNULL_END
