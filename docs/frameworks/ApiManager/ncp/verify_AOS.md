# CLOVA eKYC Verify API

Authenticate the ID or business registration card with the result of the Document API response.<br>To use the CLOVA eKYC Verify API, create an instance through  **`Invoke url`** and **`Secrect Key`**.

```kotlin
val apiManager = NcpEkycApiManager {
    idCardInvokeUrl = "Your invoke url"
    idCardSecretKey = "Your secret key"
}
```

To perform Verify API, you need to create a `NcpEkycApiManager` instance and call its `verify()` function.

```kotlin
fun NcpEkycApiManager.verify(
    documentResult: DocumentResult,
    additionalHeader: Map<String, String>? = null,
    additionalParameter: Map<String, String>? = null,
    networkTimeoutMs: Long? = null
): VerifyResult
```

The following is a code example that uses the detection result:

```kotlin
val result = apiManager.verify(documentResult)
```

## Verify API result

The `VerifyResult` object returned from the `verify()` function consists of the following information:

| Items      | Description                                                  |
| :--------- | ------------------------------------------------------------ |
| `meta`     | `Meta.SUCCESS `: success<br/>`Meta.FAILED` : connection failed<br/>`Meta.SERVER_ERROR `: when the response is not 200 when calling the server |
| `apiError` | `ApiError` : class that contains error information<br />`ApiError.code` : error code<br />`ApiError.message` : error message |
| `result`   | `VerifyInfo` : Result of authenticity certification<br />If you want to check the details, [see here](https://api-fin.ncloud-docs.com/docs/ai-application-service-ekyc-verify-api). |

