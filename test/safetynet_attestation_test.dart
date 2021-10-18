import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safetynet_attestation/safetynet_attestation.dart';

void main() {
  const MethodChannel channel = MethodChannel('safetynet_attestation');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SafetynetAttestation.platformVersion, '42');
  });
}
