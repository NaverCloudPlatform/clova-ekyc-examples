# Checking Invoke url & Secret key for using SDK

## Creating eKYC domain

To use CLOVA eKYC SDK, you must create an eKYC domain to obtain an**`Invoke url`** and **`Secrect Key`**.
For more information on creating domains, [see here](https://guide-fin.ncloud-docs.com/docs/ko/clovaekyc-apigateway).

## Verifying Invoke url & Secret key

Before using SDK functions, you should verify the **`Invoke url`** and **`Secrect Key`** that you have.<br>If the meta of the `ValidateResult` is `Meta.SUCCESS `, you can use SDK normally.

```kotlin
fun ClovaLicenseChecker.verify(invokeUrl: String, secretKey: String): ValidateResult
```

Also, you can check the verification through `isVerified()`

```kotlin
fun ClovaLicenseChecker.isVerified(): Boolean
```

> **Note**
> If validation is not performed, all features of the SDK can return empty results.

## Validate Result

The `ValidateResult` object returned from the `verify()`. function consists of the following information:

| Items      | Description                                                  |
| :--------- | ------------------------------------------------------------ |
| `meta`     | `Meta.SUCCESS `: success<br/>`Meta.FAILED` : connection failed<br/>`Meta.SERVER_ERROR `: when the response is not 200 when calling the server |
| `apiError` | `ApiError` : class that contains error information<br />`ApiError.code` : error code<br />`ApiError.message` : error message |

