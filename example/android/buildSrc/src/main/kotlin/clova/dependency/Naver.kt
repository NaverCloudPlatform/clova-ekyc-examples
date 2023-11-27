package clova.dependency

object Naver {

    private const val hmacVersion = "2.3.2"

    val hmac = DependencyNotation(
            path = "api-gateway-hmac:api-gateway-hmac",
            version = hmacVersion
    )

}