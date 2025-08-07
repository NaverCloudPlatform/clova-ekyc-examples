/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief License verification manager for SDK usage.
@interface ClovaLicenseChecker : NSObject

/// @brief Result for validation.
typedef NS_ENUM(NSUInteger, ValidateApiResult) {
    /// @brief Success.
    ValidateApiResultSuccess,
    /// @brief Network connection is lost.
    ValidateApiResultNetworkNotConnect,
    /// @brief Timeout error occurs.
    ValidateApiResultNetworkTimeout,
    /// @brief Invalid server URL.
    ValidateApiResultInvalidServerURL,
    /// @brief Receive no data from server.
    ValidateApiResultReceiveNoData,
    /// @brief Fail to decode data.
    ValidateApiResultFailToDecodeData,
    /// @brief Server response error.
    ValidateApiResultServerError,
    /// @brief Unknown error.
    ValidateApiResultUnknownError
};

/// @brief Verfication flag for SDK usage.
@property (readonly, assign) bool isVerified;

/// @brief Singleton instance of ClovaLicenseChecker.
+(instancetype)shared;
-(instancetype)init NS_UNAVAILABLE;

/// @brief Returns validation result for SDK usage.
/// @param invokeUrl Client's invoke url value for eKYC process.
/// @param secretKey Client's secret key value for eKYC process.
/// @param completion The completion closure block for getting validation result.
-(void)verify:(NSString*)invokeUrl
             :(NSString*)secretKey
             :(void (^)(ValidateApiResult))completion
NS_SWIFT_NAME(verify(invokeUrl:secretKey:completion:));

@end

NS_ASSUME_NONNULL_END
