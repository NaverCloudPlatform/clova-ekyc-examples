package clova.dependency

object Squareup {

    private const val httpVersion = "3.12.1"
    private const val retrofitVersion = "2.6.1"

    val okhttp = DependencyNotation(
        path = "com.squareup.okhttp3:okhttp",
        version = httpVersion
    )

    val okhttpLogging = DependencyNotation(
        path = "com.squareup.okhttp3:logging-interceptor",
        version = httpVersion
    )

    val retrofit = DependencyNotation(
        path = "com.squareup.retrofit2:retrofit",
        version = retrofitVersion
    )

    val retrofitConverter = DependencyNotation(
        path = "com.squareup.retrofit2:converter-gson",
        version = retrofitVersion
    )

    val gson = DependencyNotation(
        path = "com.google.code.gson:gson",
        version = "2.8.6"
    )
}
