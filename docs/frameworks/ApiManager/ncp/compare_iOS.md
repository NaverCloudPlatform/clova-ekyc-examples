# CLOVA eKYC Compare API

Authenticate the ID or business registration card with the result of the Document API response.<br>To use the CLOVA eKYC Compare API, create an instance through  **`Invoke url`** and **`Secrect Key`**.

```swift
let option = NcpEkycApiManager.Option(faceInvokeUrl: "",
                                      faceSecretKey: "")
let apiManager = NcpEkycApiManager(option: option)
```

To perform Compare API, you need to create a `NcpEkycApiManager` instance and call its `compare()` function.

```swift
func compare(face1: UIImage, face2: UIImage,
             requestId: String = UUID().uuidString,
             additionalHeader: [String: Any] = [:],
             additionalParameter: [String: Any] = [:],
             networkTimeoutMs: TimeInterval = 10000,
             completion: @escaping (Result<CompareResult, ApiError>) -> Void)
```

The following is a code example that uses the detection result:

```swift
apiManager.compare(face1: image1, face2: image2, completion: { (result) in

})
```

## Compare API result

The `CompareResult` object returned from the `compare()` function consists of the following information:

| Items                | Description                                                  |
| :------------------- | ------------------------------------------------------------ |
| `requestId`  | Request id                                                   |
| `uid`        | Uid                                                          |
| `timestamp`  | Timestamp                                                    |
| `message` | API result message.                          |
| `result` | The result meta information.                          |
| `similarity` | Similarity between two faces `Float`                         |

