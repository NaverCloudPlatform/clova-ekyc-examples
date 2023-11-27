dependencies {
    add(configurationName = "implementation", dependencyNotation = "${clova.dependency.Android.androidxCoreKtx}")
    add(configurationName = "implementation", dependencyNotation = files("$projectDir/libs/clovaeyed-android-release.aar"))
}
