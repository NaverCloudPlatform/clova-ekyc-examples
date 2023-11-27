package clova.extension

import clova.dependency.Android
import com.android.build.gradle.BaseExtension
import org.gradle.api.Project

fun BaseExtension.publish(project: Project) {
    println(message = "${project.name} : ${Android.versionName(project)}")
}
