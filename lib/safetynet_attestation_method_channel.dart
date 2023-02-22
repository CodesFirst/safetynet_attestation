import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:safetynet_attestation/models/jws_payload_model.dart';

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

  /// Request the Safety Net Attestation with a String nonce
  /// The response is the payload from the JSON Web Signature (JWS)
  @override
  Future<JWSPayloadModel> playIntegrityApiPayload({
    required int projectNumber,
    required String token,
    required String applicationId,
  }) async {
    final String payload =
        await methodChannel.invokeMethod('requestPlayIntegrityApi', {
      "cloud_project_number": projectNumber,
      "token": token,
      "application_id": applicationId,
    });

    return JWSPayloadModel.fromJson(jsonDecode(payload));
  }

  /// Request the Safety Net Attestation with a String nonce
  /// The response is the payload from the JSON Web Signature (JWS)
  @override
  Future<JWSPayloadModel> playIntegrityApiManualPayload({
    required int projectNumber,
    String keyType = "EC",
  }) async {
    final String payload = await methodChannel.invokeMethod(
        'requestPlayIntegrityApiManual',
        {"cloud_project_number": projectNumber, "ec_key_type": keyType});

    return JWSPayloadModel.fromJson(jsonDecode(payload));
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
}
