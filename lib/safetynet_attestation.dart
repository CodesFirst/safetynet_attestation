import 'package:safetynet_attestation/models/jws_payload_model.dart';

import 'safetynet_attestation_platform_interface.dart';

class SafetynetAttestation {
  Future<String?> getPlatformVersion() {
    return SafetynetAttestationPlatform.instance.getPlatformVersion();
  }

  Future<JWSPayloadModel> playIntegrityApiPayload({
    required int projectNumber,
    required String token,
    required String applicationId,
  }) {
    return SafetynetAttestationPlatform.instance.playIntegrityApiPayload(
      projectNumber: projectNumber,
      token: token,
      applicationId: applicationId,
    );
  }

  Future<JWSPayloadModel> playIntegrityApiManualPayload({
    required int projectNumber,
    String keyType = "EC",
  }) {
    return SafetynetAttestationPlatform.instance.playIntegrityApiManualPayload(
      projectNumber: projectNumber,
      keyType: keyType,
    );
  }

  Future<GooglePlayServicesAvailability?> googlePlayServicesAvailability() {
    return SafetynetAttestationPlatform.instance
        .googlePlayServicesAvailability();
  }
}
