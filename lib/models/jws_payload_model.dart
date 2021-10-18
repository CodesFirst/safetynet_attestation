import 'dart:convert';

class JWSPayloadModel {
  final String nonce;
  final int timestampMs;
  final String apkPackageName;
  final List<dynamic> apkCertificateDigestSha256;
  final String apkDigestSha256;
  final bool ctsProfileMatch;
  final bool basicIntegrity;

  
  JWSPayloadModel({
    required this.nonce, 
    required this.timestampMs, 
    required this.apkPackageName, 
    required this.apkCertificateDigestSha256, 
    required this.apkDigestSha256, 
    required this.ctsProfileMatch, 
    required this.basicIntegrity});
       

  factory JWSPayloadModel.fromJSON(Map<String, dynamic> json) => JWSPayloadModel(
        nonce: json["nonce"],
        timestampMs: json["timestampMs"],
        apkPackageName: json["apkPackageName"],
        apkCertificateDigestSha256: List.from(json["apkCertificateDigestSha256"]),
        apkDigestSha256: json["apkDigestSha256"],
        ctsProfileMatch: json["ctsProfileMatch"],
        basicIntegrity: json["basicIntegrity"]
  );


  @override
  String toString() {
    return 'nonce: $nonce\n'
        'timestampMs: $timestampMs\n'
        'apkPackageName: $apkPackageName\n'
        'apkCertificateDigestSha256: $apkCertificateDigestSha256\n'
        'apkDigestSha256: $apkDigestSha256\n'
        'ctsProfileMatch: $ctsProfileMatch\n'
        'basicIntegrity: $basicIntegrity';
  }

  String toJSON() {
    return jsonEncode({
      'nonce': nonce,
      'timestampMs': timestampMs,
      'apkPackageName': apkPackageName,
      'apkCertificateDigestSha256': apkCertificateDigestSha256,
      'apkDigestSha256': apkDigestSha256,
      'ctsProfileMatch': ctsProfileMatch,
      'basicIntegrity': basicIntegrity
    });
  }
}

