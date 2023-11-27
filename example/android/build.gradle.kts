// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    repositories {
        google()
        gradlePluginPortal()
        mavenCentral()
    }

    dependencies {
        classpath(dependencyNotation = "${clova.dependency.Android.defaultGradlePlugin}")
        classpath(dependencyNotation = "${clova.dependency.Kotlin.defaultGradlePlugin}")
        classpath(dependencyNotation = "${clova.dependency.Kotlin.dokka}")

        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module common.gradle.kts files
    }
}

allprojects {
    repositories {
        google()
        gradlePluginPortal()
        mavenCentral()
    }
}

apply {
    with(receiver = file("$rootDir/gradle/module.gradle.kts")) {
        if (exists()) {
            from(this)
        }
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
