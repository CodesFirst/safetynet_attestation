# Flutter SafetyNet Attestation plugin for Android

### Note

Original repository: https://github.com/g123k/flutter_safetynet_attestation

The problem with the original repository is that it has not been updated since 2019, for this reason this repository was created in order to maintain an updated code and eliminate the warning message when compiling a flutter application.

## What is SafetyNet?

> currently the SafetyNet will be deprecated in March, for that reason the plugin was updated to accept this new modality, what was modified will be described below.'

Please check the [documentation here](https://developer.android.com/google/play/integrity/overview).

## Getting Started

### iOS

The plugin won't work iOS, because SafetyNet is only available for Android devices.

### Android

There are 2 ways to use this plugin, one that we manage the keys ourselves and the other that is managed by Google, the first steps are for the 2 ways:

1. In the Play Console, go to the Version section of the menu on the left. Go to Settings > App Integrity. Select the Integrity API tab to get started.

2. In the Integrity APIs tab, you must select a project in the Google Cloud console, if you have not created one, do it as follows:
   _Tabspace_ a. Choose an existing project or create a new one in the Google Cloud console.
   _Tabspace_ b. Go to APIs and services and select the option to enable APIs and services.
   _Tabspace_ c. Look for the Play Integrity API. Select it and choose Enable.

##Manual

1.- Generate the private.pem `openssl genrsa -aes128 -out private.pem 2048`
2.- Generate the public.pem `openssl rsa -in private.pem -pubout > public.pem`
3.- Upload it to google, when uploading it a file with an .enc extension will be downloaded
4.- Generate the key file with `openssl rsautl -decrypt -oaep -inkey private.pem -in file_path.enc -out api_keys.txt`
5.- in the api_keys.txt file, there will be DECRYPTION_KEY and VERIFICATION_KEY, which you must add to your manifest as follows:

```xml
<meta-data android:name="decryption_api_key"
           android:value="yourapikey"/>

<meta-data android:name="verification_key"
           android:value="yourapikey"/>
```

##Automatic

Create a service account within the Google Cloud project that is linked to your app. During this account creation process, you must grant your service account the Service Account User and Service Usage Consumer roles. Generate the OAUTH2 token with your application and pass it to the plugin.

### Dart

The _SafetyNet API_ is requiring a working version of the Google Play Services. A method is available to check if they are available on the device:

```dart
SafetynetAttestation.googlePlayServicesAvailability();
```

To use pay integration manually you must add the 2 keys to the manifest and in the method pass the number of the cloud project and optionally the type of key.

```dart
SafetynetAttestation.playIntegrityApiManualPayload(projectNumber: 1);
```

or

```dart
SafetynetAttestation.playIntegrityApiManualPayload(projectNumber: 1, keyType: "EC");
```

It will then return a JWT string.

Now if you want to make the call automatically, you must pass the cloud project number and the token generated from auth2:

```dart
SafetynetAttestation.playIntegrityApiPayload(projectNumber: 1, token: "jsdkjlaskdjasjldjkasjjdl;asjkldjaskldjkjaskldjlkajs");
```

You will then receive a _JWSPayloadModel_ object with this kind of content:

```json
{
  "requestDetails": {
    "requestPackageName": "com.codesfirst.example",
    "timestampMillis": "1234444444",
    "nonce": "adasda/ajdhjasu$"
  },
  "appIntegrity": {
    "appRecognitionVerdict": "UNRECOGNIZED_VERSION",
    "packageName": "com.codesfirst.example",
    "certificateSha256Digest": ["ajkdhjahdjkhajkshdkjashjkdhkah"],
    "versionCode": "1"
  },
  "deviceIntegrity": {
    "deviceRecognitionVerdict": [
      "MEETS_BASIC_INTEGRITY",
      "MEETS_DEVICE_INTEGRITY"
    ]
  },
  "accountDetails": {
    "appLicensingVerdict": "LICENSED"
  }
}
```

<a href="https://www.buymeacoffee.com/codesfirst" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>
