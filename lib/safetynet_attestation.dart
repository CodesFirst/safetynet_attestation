import 'dart:typed_data';

import 'models/jws_payload_model.dart';
import 'safetynet_attestation_platform_interface.dart';

class SafetynetAttestation {
  Future<String?> getPlatformVersion() {
    return SafetynetAttestationPlatform.instance.getPlatformVersion();
  }

  Future<GooglePlayServicesAvailability?> googlePlayServicesAvailability() {
    return SafetynetAttestationPlatform.instance
        .googlePlayServicesAvailability();
  }

  Future<String> safetyNetAttestationJwt(String nonce) {
    return SafetynetAttestationPlatform.instance.safetyNetAttestationJwt(nonce);
  }

  Future<String> safetyNetAttestationWithFormattedNonceJwt(Uint8List nonce) {
    return SafetynetAttestationPlatform.instance
        .safetyNetAttestationWithFormattedNonceJwt(nonce);
  }

  Future<JWSPayloadModel> safetyNetAttestationPayload(String nonce) {
    return SafetynetAttestationPlatform.instance
        .safetyNetAttestationPayload(nonce);
  }

  Future<JWSPayloadModel> safetyNetAttestationWithFormattedNoncePayload(
      Uint8List nonce) {
    return SafetynetAttestationPlatform.instance
        .safetyNetAttestationWithFormattedNoncePayload(nonce);
  }
}
