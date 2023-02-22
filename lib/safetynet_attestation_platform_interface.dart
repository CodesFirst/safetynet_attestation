import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:safetynet_attestation/models/jws_payload_model.dart';

import 'safetynet_attestation_method_channel.dart';

abstract class SafetynetAttestationPlatform extends PlatformInterface {
  /// Constructs a SafetynetAttestationPlatform.
  SafetynetAttestationPlatform() : super(token: _token);

  static final Object _token = Object();

  static SafetynetAttestationPlatform _instance =
      MethodChannelSafetynetAttestation();

  /// The default instance of [SafetynetAttestationPlatform] to use.
  ///
  /// Defaults to [MethodChannelSafetynetAttestation].
  static SafetynetAttestationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SafetynetAttestationPlatform] when
  /// they register themselves.
  static set instance(SafetynetAttestationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<JWSPayloadModel> playIntegrityApiPayload({
    required int projectNumber,
    required String token,
  }) {
    throw UnimplementedError(
        'playIntegrityApiPayload() has not been implemented.');
  }

  Future<JWSPayloadModel> playIntegrityApiManualPayload({
    required int projectNumber,
    String keyType = "EC",
  }) {
    throw UnimplementedError(
        'playIntegrityApiManualPayload() has not been implemented.');
  }

  Future<GooglePlayServicesAvailability?> googlePlayServicesAvailability() {
    throw UnimplementedError(
        'googlePlayServicesAvailability() has not been implemented.');
  }
}

enum GooglePlayServicesAvailability {
  success,
  serviceMissing,
  serviceUpdating,
  serviceVersionUpdateRequired,
  serviceDisabled,
  serviceInvalid
}
