# Creating API Manager

## Checking Invoke url & Secret key

To create a `API Manager`instance,  you must check the Invoke url and Secret key you were granted.<br>For more information about **`Invoke url`** and **`Secrect Key`**, [see here](https://guide-fin.ncloud-docs.com/docs/ko/clovaekyc-apigateway).

## API Manager

You can create an instance through `NcpEkycApiManagerOptions`. <br>Please enter the correct  **`Invoke url`** and **`Secrect Key`** depending on the purpose of use

```kotlin
data class NcpEkycApiManagerOptions internal constructor(
    var idCardSecretKey: String = "",
    var idCardInvokeUrl: String = "",
    var faceSecretKey: String = "",
    var faceeInvokeUrl: String = "",
    var networkTimeoutMs: Long = 10000L
)
```

The following is a code example that create instance:

```kotlin
// If you want to use document and verify
val apiManager = NcpEkycApiManager {
    idCardInvokeUrl = "Your invoke url"
    idCardSecretKey = "Your secret key"
}

// If you want to use face compaer
val apiManager = NcpEkycApiManager {
    faceeInvokeUrl = "Your invoke url"
    faceSecretKey = "Your secret key"
}

// To use both
val apiManager = NcpEkycApiManager {
    idCardInvokeUrl = "Your document invoke url"
    idCardSecretKey = "Your document secret key"
    faceeInvokeUrl = "Your compare invoke url"
    faceSecretKey = "Your compare secret key"
}
```
