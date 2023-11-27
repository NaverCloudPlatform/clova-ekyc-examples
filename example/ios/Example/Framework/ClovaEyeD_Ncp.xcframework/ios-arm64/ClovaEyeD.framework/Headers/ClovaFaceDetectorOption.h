/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// @brief Supported stage type.
typedef NS_ENUM(NSUInteger, ClovaPipelineStageType) {
    /// @brief Detector stage.
    ClovaPipelineStageTypeDetector,
    /// @brief Landmarker stage.
    ClovaPipelineStageTypeLandmarker,
    /// @brief Mask detector stage.
    ClovaPipelineStageTypeMaskDetector,
    /// @brief Spoofing detector stage.
    ClovaPipelineStageTypeSpoofingDetector,
    /// @brief Aligner stage.
    ClovaPipelineStageTypeAligner,
    /// @brief Recognizer stage.
    ClovaPipelineStageTypeRecognizer,
    /// @brief Occlusion stage.
    ClovaPipelineStageTypeOcclusion
};

/// @brief Information of stage type for face detection.
@interface ClovaPipelineStage: NSObject

/// @brief The target stage to add the model to.
@property (nonatomic, readwrite, assign) ClovaPipelineStageType stageType;
/// @brief The filepath to the TFLite model.
@property (nonatomic, readwrite, strong, nullable) NSString* filePath;

/// @brief Initialize pipeline stage.
/// @param stageType The target stage to add the model to.
/// @param filePath The filepath to the TFLite model.
-(id _Nonnull)initWithStageType:(ClovaPipelineStageType)stageType
                       filePath:(NSString* _Nullable)filePath;

@end

/// @brief Face detector's option.
@interface ClovaDetectorOption: NSObject

/// @brief Bounding box threshold.
@property (nonatomic, readwrite, assign) float boundingBoxThreshold;
/// @brief Whether to use smoothing filter.
@property (nonatomic, readwrite, assign) bool useFilter;

@end

/// @brief Face landmarker's option.
@interface ClovaLandmarkOption: NSObject

/// @brief Whether to detect eye blink.
@property (nonatomic, readwrite, assign) bool eyeBlinkDetect;
/// @brief Whether to get 240 landmark points.
@property (nonatomic, readwrite, assign) bool support240Contour;
/// @brief Whether to use smoothing filter.
@property (nonatomic, readwrite, assign) bool useFilter;
/// @brief Whether to use adjust bounding box to landmark points.
@property (nonatomic, readwrite, assign) bool adjustBoundingBox;

@end

/// @brief Face spoof classifier's option.
@interface ClovaSpoofingOption: NSObject

/// @brief Ratio of padding.
@property (nonatomic, readwrite, assign) float spoofPadRatio;
/// @brief Spoofing threshold.
@property (nonatomic, readwrite, assign) float spoofThreshold;

@end

/// @brief Threshold values of face object.
@interface ClovaFaceThreshold: NSObject

/// @brief A threshold value to be determined as opened eye. If it is equal or greater than this value, it is opened eye.
@property (nonatomic, readwrite, assign) float eyeOpenThreshold;
/// @brief A threshold value to be determined as closed eye. If it is equal or less than this value, it is closed eye.
@property (nonatomic, readwrite, assign) float eyeCloseThreshold;
/// @brief A threshold value to be determined as opened mouth. If it is equal or greater than this value, it is opened mouth.
@property (nonatomic, readwrite, assign) float mouthOpenThreshold;
/// @brief A threshold value to be determined as closed mouth. If it is equal or less than this value, it is closed mouth.
@property (nonatomic, readwrite, assign) float mouthCloseThreshold;
/// @brief A threshold value to be determined as point being visible.
@property (nonatomic, readwrite, assign) float visibilityThreshold;
/// @brief A threshold value of face pose pitch.
@property (nonatomic, readwrite, assign) float pitchThreshold;
/// @brief A threshold value of face pose roll.
@property (nonatomic, readwrite, assign) float rollThreshold;
/// @brief A threshold value of face pose yaw.
@property (nonatomic, readwrite, assign) float yawThreshold;

@end

/// @brief Options for face detection.
@interface ClovaFaceDetectorOption: NSObject

/// @brief Information of stage types for face detection.
@property (nonatomic, readwrite, strong) NSArray<ClovaPipelineStage*>* stages;
/// @brief Indicates whether to turn on or off measuring.
@property (nonatomic, readwrite, assign) bool enableMeasure;
/// @brief Frame interval threshold to detect facial motion.
@property (nonatomic, readwrite, assign) int motionFrameInterval;
/// @brief Face detector's option.
@property (nonatomic, readwrite, strong) ClovaDetectorOption* detectorOptions;
/// @brief Face landmarker's option.
@property (nonatomic, readwrite, strong) ClovaLandmarkOption* landmarkOptions;
/// @brief Face spoof classifier's option.
@property (nonatomic, readwrite, strong) ClovaSpoofingOption* spoofingOptions;
/// @brief Threshold values of face object.
@property (nonatomic, readwrite, strong) ClovaFaceThreshold* faceThreshold;
/// @brief Initialize ClovaFaceDetectorOption.
-(id)init;

@end

NS_ASSUME_NONNULL_END
