package clova

import org.gradle.api.Project
import java.io.File
import java.util.*

val Project.headNumber: Int
    get() = readMajorVersion() ?: propertyOrNull(name = "head.number")?.toInt() ?: 0

val Project.buildNumber: Int
    get() = propertyOrNull(name = "build.number")?.toInt() ?: 9999

val Project.deployKey: String?
    get() = propertyOrNull(name = "build.deployKey")

val Project.cmakeBuildType: String
    get() = propertyOrNull(name = "cmakeBuildType") ?: "Release"

val Project.externalBuild: Boolean
    get() = propertyOrNull(name = "externalBuild")?.toBoolean() ?: false

private fun Project.propertyOrNull(name: String) =
    if (hasProperty(name)) {
        property(name) as String
    } else {
        null
    }

private fun Project.readMajorVersion(): Int? {
    var majorVersionFile = File(rootDir, "majorVersion")
    if (!majorVersionFile.isFile) {
        majorVersionFile = File(rootDir, "../../core/majorVersion")
        if (!majorVersionFile.isFile) {
            majorVersionFile = File(rootDir, "../../../../../core/majorVersion")
        }
    }

    try {
        return Scanner(majorVersionFile).nextLine().toInt()
    } catch (e: Exception) {
        // ignore
    }
    return null
}
