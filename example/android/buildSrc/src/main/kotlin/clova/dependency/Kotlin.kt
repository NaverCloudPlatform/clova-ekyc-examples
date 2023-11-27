package clova.dependency

object Kotlin {
    private const val version = "1.8.0"

    val defaultGradlePlugin = DependencyNotation(
        path = "org.jetbrains.kotlin:kotlin-gradle-plugin",
        version = version
    )

    val dokka = DependencyNotation(
        path = "org.jetbrains.dokka:dokka-gradle-plugin",
        version = "1.8.10"
    )

    val stdlib = DependencyNotation(
        path = "org.jetbrains.kotlin:kotlin-stdlib-jdk8",
        version = version
    )

    val reflect = DependencyNotation(
        path = "org.jetbrains.kotlin:kotlin-reflect",
        version = version
    )

    val coroutines = DependencyNotation(
        path = "org.jetbrains.kotlinx:kotlinx-coroutines-android",
        version = "1.4.3"
    )

    val junit = DependencyNotation(
        path = "org.jetbrains.kotlin:kotlin-test-junit",
        version = version
    )
}
