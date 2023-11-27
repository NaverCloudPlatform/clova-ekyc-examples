plugins {
    `kotlin-dsl`
    `kotlin-dsl-precompiled-script-plugins`
}

val kotlin = "1.8.0"
val androidGradle = "7.4.1"
val okhttp = "4.9.3"

repositories {
    mavenCentral()
    google()
}

dependencies {
    implementation(dependencyNotation = kotlin(module = "gradle-plugin", version = kotlin))
    implementation(dependencyNotation = "com.android.tools.build:gradle:$androidGradle")
    implementation(dependencyNotation = "com.squareup.okhttp3:okhttp:$okhttp")
}
