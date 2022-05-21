import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:safetynet_attestation/models/jws_payload_model.dart';
import 'package:safetynet_attestation/safetynet_attestation.dart';
import 'package:safetynet_attestation/safetynet_attestation_method_channel.dart';
import 'package:safetynet_attestation/safetynet_attestation_platform_interface.dart';

class MockSafetynetAttestationPlatform
    with MockPlatformInterfaceMixin
    implements SafetynetAttestationPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<GooglePlayServicesAvailability?> googlePlayServicesAvailability() {
    // TODO: implement googlePlayServicesAvailability
    throw UnimplementedError();
  }

  @override
  Future<String> safetyNetAttestationJwt(String nonce) {
    // TODO: implement safetyNetAttestationJwt
    throw UnimplementedError();
  }

  @override
  Future<JWSPayloadModel> safetyNetAttestationPayload(String nonce) {
    // TODO: implement safetyNetAttestationPayload
    throw UnimplementedError();
  }

  @override
  Future<String> safetyNetAttestationWithFormattedNonceJwt(Uint8List nonce) {
    // TODO: implement safetyNetAttestationWithFormattedNonceJwt
    throw UnimplementedError();
  }

  @override
  Future<JWSPayloadModel> safetyNetAttestationWithFormattedNoncePayload(
      Uint8List nonce) {
    // TODO: implement safetyNetAttestationWithFormattedNoncePayload
    throw UnimplementedError();
  }
}

void main() {
  final SafetynetAttestationPlatform initialPlatform =
      SafetynetAttestationPlatform.instance;

  test('$MethodChannelSafetynetAttestation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSafetynetAttestation>());
  });

  test('getPlatformVersion', () async {
    SafetynetAttestation safetynetAttestationPlugin = SafetynetAttestation();
    MockSafetynetAttestationPlatform fakePlatform =
        MockSafetynetAttestationPlatform();
    SafetynetAttestationPlatform.instance = fakePlatform;

    expect(await safetynetAttestationPlugin.getPlatformVersion(), '42');
  });
}
