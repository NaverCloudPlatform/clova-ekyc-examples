# Getting started with Android development

## Supported specifications

The minimum specifications required to use CLOVA eKYC SDK are as follows:

- AOS 7.0, Android SDK v24 or later

## Using SDK

The CLOVA eKYC SDK for Android is provided in [AAR form](https://developer.android.com/studio/projects/android-library#psd-add-library-dependency).  
You can use the Kotlin interface in Android projects to utilize the CLOVA eKYC SDK.

```shell
.
├── sample/         
      └── libs/
           ├── clovaeyed-android-debug.aar
           └── clovaeyed-android-release.aar 
```

### For 3rd party

You can just locate the AAR file of the module you want to use in your project and add it to your build dependencies. The default library location in a project is `app/libs` and you can copy the AAR file from the sample project's `app/libs` to this location, then add dependencies in the `app/build.gradle` file as follows:

```groovy
dependencies {
    implementation files('clovaeyed-android-release.aar')
}
```

For additional information regarding Android build dependency, refer to [Adding AAR or JAR as a dependency](https://developer.android.com/studio/projects/android-library#psd-add-aar-jar-dependency).
