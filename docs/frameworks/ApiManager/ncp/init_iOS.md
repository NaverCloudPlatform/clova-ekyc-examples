# Creating API Manager

## Checking Invoke url & Secret key

To create a `API Manager`instance,  you must check the Invoke url and Secret key you were granted.<br>For more information about **`Invoke url`** and **`Secrect Key`**, [see here](https://guide-fin.ncloud-docs.com/docs/ko/clovaekyc-apigateway).

## API Manager

You can create an instance through `NcpEkycApiManagerOptions`. <br>Please enter the correct  **`Invoke url`** and **`Secrect Key`** depending on the purpose of use

```swift
let option = NcpEkycApiManager.Option(idCardInvokeUrl: "",
                                      idCardSecretKey: "",
                                      faceInvokeUrl: "",
                                      faceSecretKey: "")
```


The following is a code example that create instance:

```swift
let option = NcpEkycApiManager.Option(idCardInvokeUrl: "",
                                      idCardSecretKey: "",
                                      faceInvokeUrl: "",
                                      faceSecretKey: "")
let apiManager = NcpEkycApiManager(option: option)
```
