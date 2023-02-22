import 'package:flutter_test/flutter_test.dart';
import 'package:safetynet_attestation/safetynet_attestation.dart';
import 'package:safetynet_attestation/safetynet_attestation_platform_interface.dart';
import 'package:safetynet_attestation/safetynet_attestation_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSafetynetAttestationPlatform
    with MockPlatformInterfaceMixin
    implements SafetynetAttestationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SafetynetAttestationPlatform initialPlatform = SafetynetAttestationPlatform.instance;

  test('$MethodChannelSafetynetAttestation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSafetynetAttestation>());
  });

  test('getPlatformVersion', () async {
    SafetynetAttestation safetynetAttestationPlugin = SafetynetAttestation();
    MockSafetynetAttestationPlatform fakePlatform = MockSafetynetAttestationPlatform();
    SafetynetAttestationPlatform.instance = fakePlatform;

    expect(await safetynetAttestationPlugin.getPlatformVersion(), '42');
  });
}
