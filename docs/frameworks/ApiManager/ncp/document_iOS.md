# CLOVA eKYC Document API

Recognize the uploaded image and respond to the recognition result with text. The recognition results can be used as input for Verify API calls.<br>To use the CLOVA eKYC Document API, create an instance through I **`Invoke url`** and **`Secrect Key`**.

```swift
let option = NcpEkycApiManager.Option(idCardInvokeUrl: "",
                                      idCardSecretKey: "")
let apiManager = NcpEkycApiManager(option: option)
```

Recognize the uploaded image and respond to the recognition result with text. The recognition results can be used as input for Verify API calls. 
To perform Document API, you need to create a `NcpEkycApiManager` instance and call its `document()` function.

```swift
func document(image: UIImage,
              requestId: String = UUID().uuidString,
              additionalHeader: [String: Any] = [:],
              additionalParameter: [String: Any] = [:],
              networkTimeoutMs: TimeInterval = 10000,
              completion: @escaping (Result<Document, ApiError>) -> Void)
```

The following is a code example that uses the detection result:

```swift
apiManager.document(image: image, completion: { (result) in

})
```

## Document API result

The `DocumentResult` object returned from the `document()` function:

[see here](https://api-fin.ncloud-docs.com/docs/ai-application-service-ekyc-document-api)

