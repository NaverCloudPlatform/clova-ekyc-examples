# CLOVA eKYC Verify API

Authenticate the ID or business registration card with the result of the Document API response.<br>To use the CLOVA eKYC Verify API, create an instance through  **`Invoke url`** and **`Secrect Key`**.

```swift
let option = NcpEkycApiManager.Option(idCardInvokeUrl: "",
                                      idCardSecretKey: "")
let apiManager = NcpEkycApiManager(option: option)
```

To perform Verify API, you need to create a `NcpEkycApiManager` instance and call its `verify()` function.

```swift
func verify(document: Document,
            additionalHeader: [String: Any] = [:],
            additionalParameter: [String: Any] = [:],
            networkTimeoutMs: TimeInterval = 10000,
            completion: @escaping (Result<VerifyResult, ApiError>) -> Void)
```

The following is a code example that uses the detection result:

```swift
apiManager.verify(document: document, completion: { (result) in

})
```

## Verify API result

The `VerifyResult` object returned from the `verify()` function:

[see here](https://api-fin.ncloud-docs.com/docs/ai-application-service-ekyc-verify-api)

