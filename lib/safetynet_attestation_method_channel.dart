import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/jws_payload_model.dart';
import 'safetynet_attestation_platform_interface.dart';

/// An implementation of [SafetynetAttestationPlatform] that uses method channels.
class MethodChannelSafetynetAttestation extends SafetynetAttestationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('safetynet_attestation');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  //Check if you have the google play service enabled
  @override
  Future<GooglePlayServicesAvailability?>
      googlePlayServicesAvailability() async {
    final String result =
        await methodChannel.invokeMethod('checkGooglePlayServicesAvailability');

    switch (result) {
      case 'success':
        return GooglePlayServicesAvailability.success;
      case 'service_missing':
        return GooglePlayServicesAvailability.serviceMissing;
      case 'service_updating':
        return GooglePlayServicesAvailability.serviceUpdating;
      case 'service_version_update_required':
        return GooglePlayServicesAvailability.serviceVersionUpdateRequired;
      case 'service_disabled':
        return GooglePlayServicesAvailability.serviceDisabled;
      case 'service_invalid':
        return GooglePlayServicesAvailability.serviceInvalid;
    }

    return null;
  }

  /// Request the Safety Net Attestation with a String nonce
  /// The response is formatted as a JSON Web Signature (JWS)
  @override
  Future<String> safetyNetAttestationJwt(String nonce) async {
    final String result = await methodChannel.invokeMethod(
        'requestSafetyNetAttestation',
        {"nonce_string": nonce, "include_payload": false});
    return result;
  }

  /// Request the Safety Net Attestation with a list of bytes
  /// The response is formatted as a JSON Web Signature (JWS)
  @override
  Future<String> safetyNetAttestationWithFormattedNonceJwt(
      Uint8List nonce) async {
    final String result = await methodChannel.invokeMethod(
        'requestSafetyNetAttestation',
        {"nonce_bytes": nonce, "include_payload": false});
    return result;
  }

  /// Request the Safety Net Attestation with a String nonce
  /// The response is the payload from the JSON Web Signature (JWS)
  @override
  Future<JWSPayloadModel> safetyNetAttestationPayload(String nonce) async {
    final String payload = await methodChannel.invokeMethod(
        'requestSafetyNetAttestation',
        {"nonce_string": nonce, "include_payload": true});

    return JWSPayloadModel.fromJSON(jsonDecode(payload));
  }

  /// Request the Safety Net Attestation with a list of bytes
  /// The response is the payload from the JSON Web Signature (JWS)
  @override
  Future<JWSPayloadModel> safetyNetAttestationWithFormattedNoncePayload(
      Uint8List nonce) async {
    final String payload = await methodChannel.invokeMethod(
        'requestSafetyNetAttestation',
        {"nonce_bytes": nonce, "include_payload": true});

    return JWSPayloadModel.fromJSON(jsonDecode(payload));
  }
}
