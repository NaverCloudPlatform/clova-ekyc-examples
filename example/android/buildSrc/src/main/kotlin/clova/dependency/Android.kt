package clova.dependency

import clova.buildNumber
import clova.headNumber
import org.gradle.api.Project
import java.text.SimpleDateFormat
import java.util.*

object Android {
    val defaultGradlePlugin = DependencyNotation(
        path = "com.android.tools.build:gradle",
        version = "7.4.1"
    )

    const val compileSdk = 33
    const val buildToolsVersion = "33.0.0"
    const val minSdk = 24
    const val targetSdk = 33

    val versionName: (Project) -> String = { project ->
        buildString {
            val year = SimpleDateFormat("yyyy-MM-dd", Locale.ROOT).let { dateFormat ->
                dateFormat.timeZone = TimeZone.getTimeZone("UTC")
                dateFormat.format(Date()).toString().substring(range = 2..3)
            }

            val week = Calendar.getInstance().let { calendar ->
                calendar.minimalDaysInFirstWeek = 4
                calendar.firstDayOfWeek = Calendar.MONDAY
                calendar.time = Date()
                String.format(format = "%02d", calendar[Calendar.WEEK_OF_YEAR])
            }

            append("${project.headNumber}.$year$week.${project.buildNumber}")
        }
    }

    val versionCode: (Project) -> Int = { project -> project.buildNumber }

    val androidxCoreKtx = DependencyNotation(
        path = "androidx.core:core-ktx",
        version = "1.7.0"
    )

    val androidxAppCompat = DependencyNotation(
        path = "androidx.appcompat:appcompat",
        version = "1.3.1"
    )

    val androidMaterial = DependencyNotation(
        path = "com.google.android.material:material",
        version = "1.4.0"
    )

    val androidxConstraintlayout = DependencyNotation(
        path = "androidx.constraintlayout:constraintlayout",
        version = "2.1.0"
    )

    private const val androidxNavigationVersion = "2.3.5"

    val androidxNavigationFragmentKtx = DependencyNotation(
        path = "androidx.navigation:navigation-fragment-ktx",
        version = androidxNavigationVersion
    )
    val androidxNavigationUiKtx = DependencyNotation(
        path = "androidx.navigation:navigation-ui-ktx",
        version = androidxNavigationVersion
    )
    val androidxNavigationDynamicFeaturesFragment = DependencyNotation(
        path = "androidx.navigation:navigation-dynamic-features-fragment",
        version = androidxNavigationVersion
    )

    private const val androidxCameraVersion = "1.1.0"

    val androidxCameraCore = DependencyNotation(
        path = "androidx.camera:camera-core",
        version = androidxCameraVersion
    )
    val androidxCamera2 = DependencyNotation(
        path = "androidx.camera:camera-camera2",
        version = androidxCameraVersion
    )
    val androidxCameraLifeCycle = DependencyNotation(
        path = "androidx.camera:camera-lifecycle",
        version = androidxCameraVersion
    )

    val androidxCameraView = DependencyNotation(
        path = "androidx.camera:camera-view",
        version = androidxCameraVersion
    )

    val androidxCameraExtension = DependencyNotation(
        path = "androidx.camera:camera-extensions",
        version = androidxCameraVersion
    )

    val androidxJunit = DependencyNotation(
        path = "androidx.test.ext:junit",
        version = "1.1.3"
    )

    val androidxEspressoCore = DependencyNotation(
        path = "androidx.test.espresso:espresso-core",
        version = "3.4.0"
    )

    val androidxBenchmark = DependencyNotation(
        path = "androidx.benchmark:benchmark-junit4",
        version = "1.0.0"
    )

    val timber = DependencyNotation(
        path = "com.jakewharton.timber:timber",
        version = "5.0.1"
    )
}
