# CLOVA eKYC Document API

Recognize the uploaded image and respond to the recognition result with text. The recognition results can be used as input for Verify API calls.<br>To use the CLOVA eKYC Document API, create an instance through I **`Invoke url`** and **`Secrect Key`**.

```kotlin
val apiManager = NcpEkycApiManager {
    idCardInvokeUrl = "Your invoke url"
    idCardSecretKey = "Your secret key"
}
```

Recognize the uploaded image and respond to the recognition result with text. The recognition results can be used as input for Verify API calls. 
To perform Document API, you need to create a `NcpEkycApiManager` instance and call its `document()` function.

```kotlin
fun NcpEkycApiManager.document(
    requestId: String = UUID.randomUUID().toString(),
    bitmap: Bitmap,
    additionalHeader: Map<String, String>? = null,
    additionalParameter: Map<String, String>? = null,
    networkTimeoutMs: Long? = null
): DocumentResult
```

The following is a code example that uses the detection result:

```kotlin
val result = apiManager.document(bitmap = image)
```

## Document API result

The `DocumentResult` object returned from the `document()` function consists of the following information:

| Items| Description|
|:----------|----------|
| `meta` | `Meta.SUCCESS `: success<br/>`Meta.FAILED` : connection failed<br/>`Meta.SERVER_ERROR `: when the response is not 200 when calling the server |
| `apiError` | `ApiError` : class that contains error information<br />`ApiError.code` : error code<br />`ApiError.message` : error message |
| `result` | `Document` : ID Infomation<br />If you want to check the details, [see here](https://api-fin.ncloud-docs.com/docs/ai-application-service-ekyc-document-api). |

