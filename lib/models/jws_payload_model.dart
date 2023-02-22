import 'dart:convert';

JWSPayloadModel jwsPayloadModelFromJson(String str) =>
    JWSPayloadModel.fromJson(json.decode(str));

String jwsPayloadModelToJson(JWSPayloadModel data) =>
    json.encode(data.toJson());

class JWSPayloadModel {
  JWSPayloadModel({
    required this.requestDetails,
    required this.appIntegrity,
    required this.deviceIntegrity,
    required this.accountDetails,
  });

  RequestDetails requestDetails;
  AppIntegrity appIntegrity;
  DeviceIntegrity deviceIntegrity;
  AccountDetails accountDetails;

  factory JWSPayloadModel.fromJson(Map<String, dynamic> json) =>
      JWSPayloadModel(
        requestDetails: RequestDetails.fromJson(json["requestDetails"]),
        appIntegrity: AppIntegrity.fromJson(json["appIntegrity"]),
        deviceIntegrity: DeviceIntegrity.fromJson(json["deviceIntegrity"]),
        accountDetails: AccountDetails.fromJson(json["accountDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "requestDetails": requestDetails.toJson(),
        "appIntegrity": appIntegrity.toJson(),
        "deviceIntegrity": deviceIntegrity.toJson(),
        "accountDetails": accountDetails.toJson(),
      };
}

class AccountDetails {
  AccountDetails({
    required this.appLicensingVerdict,
  });

  String appLicensingVerdict;

  factory AccountDetails.fromJson(Map<String, dynamic> json) => AccountDetails(
        appLicensingVerdict: json["appLicensingVerdict"],
      );

  Map<String, dynamic> toJson() => {
        "appLicensingVerdict": appLicensingVerdict,
      };
}

class AppIntegrity {
  AppIntegrity({
    required this.appRecognitionVerdict,
    required this.packageName,
    required this.certificateSha256Digest,
    required this.versionCode,
  });

  String appRecognitionVerdict;
  String packageName;
  List<String> certificateSha256Digest;
  String versionCode;

  factory AppIntegrity.fromJson(Map<String, dynamic> json) => AppIntegrity(
        appRecognitionVerdict: json["appRecognitionVerdict"],
        packageName: json["packageName"],
        certificateSha256Digest:
            List<String>.from(json["certificateSha256Digest"].map((x) => x)),
        versionCode: json["versionCode"],
      );

  Map<String, dynamic> toJson() => {
        "appRecognitionVerdict": appRecognitionVerdict,
        "packageName": packageName,
        "certificateSha256Digest":
            List<dynamic>.from(certificateSha256Digest.map((x) => x)),
        "versionCode": versionCode,
      };
}

class DeviceIntegrity {
  DeviceIntegrity({
    required this.deviceRecognitionVerdict,
  });

  List<String> deviceRecognitionVerdict;

  factory DeviceIntegrity.fromJson(Map<String, dynamic> json) =>
      DeviceIntegrity(
        deviceRecognitionVerdict:
            List<String>.from(json["deviceRecognitionVerdict"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "deviceRecognitionVerdict":
            List<dynamic>.from(deviceRecognitionVerdict.map((x) => x)),
      };
}

class RequestDetails {
  RequestDetails({
    required this.requestPackageName,
    required this.timestampMillis,
    required this.nonce,
  });

  String requestPackageName;
  String timestampMillis;
  String nonce;

  factory RequestDetails.fromJson(Map<String, dynamic> json) => RequestDetails(
        requestPackageName: json["requestPackageName"],
        timestampMillis: json["timestampMillis"],
        nonce: json["nonce"],
      );

  Map<String, dynamic> toJson() => {
        "requestPackageName": requestPackageName,
        "timestampMillis": timestampMillis,
        "nonce": nonce,
      };
}
