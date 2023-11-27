# Getting started with iOS development

## Supported specifications

The minimum specifications required to use CLOVA eKYC SDK are as follows:

- iOS 13.0 or later

## Using SDK

The CLOVA eKYC SDK for iOS is provided in [XCFramework form](https://help.apple.com/xcode/mac/11.4/#/dev6f6ac218b).  
You can use the Swift interface in iOS projects to utilize the CLOVA eKYC SDK. The SDK is deployed as a compressed file named clova-eyed-sample-ios-${version}.zip and is accompanied by a sample project with the following composition:

```shell
.
├── EyeD/    
      └── Sample/   
            └── Framework/
                    ├── ClovaEyeD.xcframework
                    └── ClovaEyeD_Static.xcframework    
```

### Via Cocoapods

If you can access NAVER's internal repository, you can directly import the files of SDK via Cocoapods. You can add the following phrase to the Podfile and add dependencies through `pod install`. 

```Ruby
pod 'ClovaEyeD'
```

### Via XCFramework

Simply locate the XCFramework file in your project and add it to your build dependencies. In your XCode project, add the following dependencies:

![eyed](../images/eyed_xcf.png)
