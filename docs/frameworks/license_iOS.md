# Checking Invoke url & Secret key for using SDK

## Creating eKYC domain

To use CLOVA eKYC SDK, you must create an eKYC domain to obtain an**`Invoke url`** and **`Secrect Key`**.
For more information on creating domains, [see here](https://guide-fin.ncloud-docs.com/docs/ko/clovaekyc-apigateway).

## Verifying Invoke url & Secret key

Before using SDK functions, you should verify the **`Invoke url`** and **`Secrect Key`** that you have.<br>If the result of `verify` is true, you can use SDK normally.

```swift
func ClovaLicenseChecker.verify(invokeUrl: String, secretKey: String, completion: @escaping (Bool) -> Void)
```

Also, you can check the verification through `isVerified`

```swift
var ClovaLicenseChecker.isVerified: Bool
```

> **Note**
> If validation is not performed, all features of the SDK can return empty results.
