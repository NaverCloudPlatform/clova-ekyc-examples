package clova.dependency

data class DependencyNotation internal constructor(
    val path: String,
    val version: String
) {
    override fun toString() = "$path:$version"
}
