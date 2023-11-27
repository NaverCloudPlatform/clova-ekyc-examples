# CLOVA eKYC Compare API

Authenticate the ID or business registration card with the result of the Document API response.<br>To use the CLOVA eKYC Compare API, create an instance through  **`Invoke url`** and **`Secrect Key`**.

```kotlin
val apiManager = NcpEkycApiManager {
    faceInvokeUrl = "Your invoke url"
    faceSecretKey = "Your secret key"
}
```

To perform Compare API, you need to create a `NcpEkycApiManager` instance and call its `compare()` function.

```kotlin
fun NcpEkycApiManager.compare(
    requestId: String = UUID.randomUUID().toString(),
    face1: Bitmap,
    face2: Bitmap,
    additionalHeader: Map<String, String>? = null,
    additionalParameter: Map<String, String>? = null,
    networkTimeoutMs: Long? = null
): CompareResult
```

The following is a code example that uses the detection result:

```kotlin
val result = apiManager.compare(faceImage1, faceImage2)
```

## Compare API result

The `CompareResult` object returned from the `compare()` function consists of the following information:

| Items                | Description                                                  |
| :------------------- | ------------------------------------------------------------ |
| `meta`               | `Meta.SUCCESS `: success<br/>`Meta.FAILED` : connection failed<br/>`Meta.SERVER_ERROR `: when the response is not 200 when calling the server |
| `apiError`           | `ApiError` : class that contains error information<br />`ApiError.code` : error code<br />`ApiError.message` : error message |
| `result`             | `Compare` : Result of compare                                |
| `Compare.requestId`  | Request id                                                   |
| `Compare.uid`        | Uid                                                          |
| `Compare.timestamp`  | Timestamp                                                    |
| `Compare.similarity` | Similarity between two faces `Float`                         |

