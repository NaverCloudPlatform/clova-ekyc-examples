import clova.dependency.Android
import clova.dependency.Squareup
import clova.externalBuild

val isExternalBuild = !file("internal.gradle.kts").exists() or externalBuild

plugins {
    id("com.android.application")
    kotlin(module = "android")
}

android {
    compileSdk = Android.compileSdk
    buildToolsVersion = Android.buildToolsVersion

    defaultConfig {
        applicationId = "ai.clova.eyed.example.ncp"
        minSdk = Android.minSdk
        targetSdk = Android.targetSdk
        versionCode = 4
        versionName = "${Android.versionName(project)}"
    }

    signingConfigs {
        getByName("debug") {
            storeFile = file("demo.keystore")
            storePassword = "demokey"
            keyAlias = "key"
            keyPassword = "demokey"
        }

        create("release") {
            storeFile = file("demo.keystore")
            storePassword = "demokey"
            keyAlias = "key"
            keyPassword = "demokey"
        }
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("debug")
        }

        getByName("release") {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            signingConfig = signingConfigs.getByName("release")
        }
    }

    flavorDimensions += "client"
    productFlavors {
        create("ncp") {
            dimension = "client"
            matchingFallbacks += listOf("ncp")
        }
    }

    buildFeatures {
        viewBinding = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    packagingOptions {
        jniLibs.pickFirsts.add("**/*.so")
    }

    kotlinOptions {
        jvmTarget = "11"
        freeCompilerArgs = listOf(
            "-Xuse-experimental=kotlinx.coroutines.ObsoleteCoroutinesApi",
            "-Xuse-experimental=kotlinx.coroutines.ExperimentalCoroutinesApi"
        )
    }

    androidResources {
        noCompress("fmt")
    }

    applicationVariants.all {
        outputs.all {
            (this as com.android.build.gradle.internal.api.BaseVariantOutputImpl).outputFileName =
                "clovaeyed-example-ncp-${buildType.name}-${Android.versionName(project)}.apk"
        }
    }
}

dependencies {
    implementation(dependencyNotation = "${clova.dependency.Kotlin.stdlib}")
    implementation(dependencyNotation = "${clova.dependency.Kotlin.reflect}")
    implementation(dependencyNotation = "${Android.androidxCoreKtx}")
    implementation(dependencyNotation = "${Android.androidxAppCompat}")
    implementation(dependencyNotation = "${Android.androidMaterial}")
    implementation(dependencyNotation = "${Android.androidxConstraintlayout}")

    implementation(dependencyNotation = "${Android.androidxNavigationFragmentKtx}")
    implementation(dependencyNotation = "${Android.androidxNavigationUiKtx}")
    implementation(dependencyNotation = "${Android.androidxNavigationDynamicFeaturesFragment}")

    implementation(dependencyNotation = "${Android.androidxCameraCore}")
    implementation(dependencyNotation = "${Android.androidxCamera2}")
    implementation(dependencyNotation = "${Android.androidxCameraLifeCycle}")
    implementation(dependencyNotation = "${Android.androidxCameraView}")
    implementation(dependencyNotation = "${Android.androidxCameraExtension}")

    implementation(dependencyNotation = "${Squareup.okhttp}")
    implementation(dependencyNotation = "${Squareup.okhttpLogging}")
    implementation(dependencyNotation = "${Squareup.gson}")

    testImplementation(dependencyNotation = "${clova.dependency.Kotlin.junit}")
    androidTestImplementation(dependencyNotation = "${Android.androidxJunit}")
    androidTestImplementation(dependencyNotation = "${Android.androidxEspressoCore}")

    implementation ("com.airbnb.android:lottie:3.4.0")
    implementation ("androidx.exifinterface:exifinterface:1.3.3")
}

apply {
    val internal = file("internal.gradle.kts")
    val external = file("external.gradle.kts")

    from(
        if (!isExternalBuild) {
            internal
        } else {
            external
        }
    )
}

tasks.register("prepareKotlinBuildScriptModel"){}
