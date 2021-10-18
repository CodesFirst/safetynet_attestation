import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safetynet_attestation/models/jws_payload_model.dart';
import 'package:safetynet_attestation/safetynet_attestation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GooglePlayServicesAvailability? _gmsStatus;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    GooglePlayServicesAvailability? gmsAvailability;
    try {
      gmsAvailability = await SafetynetAttestation.googlePlayServicesAvailability();
    } on PlatformException {
      gmsAvailability = null;
    }

    if (!mounted) return;

    setState(() {
      _gmsStatus = gmsAvailability;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SafetyNet Attestation plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Google Play Services status: ${_gmsStatus ?? 'unknown'}',
              textAlign: TextAlign.center,
            ),
            Offstage(
              offstage: _gmsStatus != GooglePlayServicesAvailability.success,
              child: const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: SafetyNetAttestationWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SafetyNetAttestationWidget extends StatefulWidget {
  const SafetyNetAttestationWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SafetyNetAttestationWidgetState();
}

class _SafetyNetAttestationWidgetState
    extends State<SafetyNetAttestationWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    } else {
      return MaterialButton(
        onPressed: () {
          requestSafetyNetAttestation();
          setState(() {
            isLoading = true;
          });
        },
        color: Colors.blueAccent,
        child: const Text('Request SafetyNet Attestation'),
      );
    }
  }

  void requestSafetyNetAttestation() async {
    String dialogTitle, dialogMessage;
    try {
      JWSPayloadModel res = await SafetynetAttestation.safetyNetAttestationPayload('nonce');

      dialogTitle = 'SafetyNet Attestation Payload';
      dialogMessage = res.toString();
    } catch (e) {
      dialogTitle = 'ERROR - SafetyNet Attestation Payload';

      if (e is PlatformException) {
        dialogMessage = e.message ?? "Error";
      } else {
        dialogMessage = e.toString();
      }
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(dialogTitle),
            content: Text(dialogMessage),
            actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'))
            ],
          );
        });

    setState(() {
      isLoading = false;
    });
  }
}
