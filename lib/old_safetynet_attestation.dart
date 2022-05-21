// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';

// class SafetynetAttestation {
//   static const MethodChannel _channel = MethodChannel('safetynet_attestation');

//   static Future<String?> get platformVersion async {
//     final String? version = await _channel.invokeMethod('getPlatformVersion');
//     return version;
//   }

//   //Check if you have the google play service enabled
//   static Future<GooglePlayServicesAvailability?>
//       googlePlayServicesAvailability() async {
//     final String result =
//         await _channel.invokeMethod('checkGooglePlayServicesAvailability');

//     switch (result) {
//       case 'success':
//         return GooglePlayServicesAvailability.success;
//       case 'service_missing':
//         return GooglePlayServicesAvailability.serviceMissing;
//       case 'service_updating':
//         return GooglePlayServicesAvailability.serviceUpdating;
//       case 'service_version_update_required':
//         return GooglePlayServicesAvailability.serviceVersionUpdateRequired;
//       case 'service_disabled':
//         return GooglePlayServicesAvailability.serviceDisabled;
//       case 'service_invalid':
//         return GooglePlayServicesAvailability.serviceInvalid;
//     }

//     return null;
//   }

//   /// Request the Safety Net Attestation with a String nonce
//   /// The response is formatted as a JSON Web Signature (JWS)
//   static Future<String> safetyNetAttestationJwt(String nonce) async {
//     final String result = await _channel.invokeMethod(
//         'requestSafetyNetAttestation',
//         {"nonce_string": nonce, "include_payload": false});
//     return result;
//   }

//   /// Request the Safety Net Attestation with a list of bytes
//   /// The response is formatted as a JSON Web Signature (JWS)
//   static Future<String> safetyNetAttestationWithFormattedNonceJwt(
//       Uint8List nonce) async {
//     final String result = await _channel.invokeMethod(
//         'requestSafetyNetAttestation',
//         {"nonce_bytes": nonce, "include_payload": false});
//     return result;
//   }

//   /// Request the Safety Net Attestation with a String nonce
//   /// The response is the payload from the JSON Web Signature (JWS)
//   static Future<JWSPayloadModel> safetyNetAttestationPayload(
//       String nonce) async {
//     final String payload = await _channel.invokeMethod(
//         'requestSafetyNetAttestation',
//         {"nonce_string": nonce, "include_payload": true});

//     return JWSPayloadModel.fromJSON(jsonDecode(payload));
//   }

//   /// Request the Safety Net Attestation with a list of bytes
//   /// The response is the payload from the JSON Web Signature (JWS)
//   static Future<JWSPayloadModel> safetyNetAttestationWithFormattedNoncePayload(
//       Uint8List nonce) async {
//     final String payload = await _channel.invokeMethod(
//         'requestSafetyNetAttestation',
//         {"nonce_bytes": nonce, "include_payload": true});

//     return JWSPayloadModel.fromJSON(jsonDecode(payload));
//   }
// }

// //Enum of options
// enum GooglePlayServicesAvailability {
//   success,
//   serviceMissing,
//   serviceUpdating,
//   serviceVersionUpdateRequired,
//   serviceDisabled,
//   serviceInvalid
// }
