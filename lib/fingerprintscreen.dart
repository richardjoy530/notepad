import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'main.dart';

class FingerPrintListener extends StatefulWidget {
  @override
  _FingerPrintListenerState createState() => _FingerPrintListenerState();
}

class _FingerPrintListenerState extends State<FingerPrintListener> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {});
      authenticated =
          await auth.authenticateWithBiometrics(localizedReason: null);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
    }
    return authenticated;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authenticate(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            //snapshot.data is equal to the value returned from getPinEnable()
            return snapshot.data ? MyTabbedHome() : FingerPrintListener();
          } else {
            throw CircularProgressIndicator(); //you should handle this case if your function returns null
          }
        } else {
          print('circling');
          return FingerPrint();
        }
      },
    );
  }
}

class FingerPrint extends StatefulWidget {
  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Fingerprint',
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'Authentication',
            style: TextStyle(
                fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place your fingertip on the fingerprint sensor to verify your identity',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.fingerprint,
            size: 30,
          )
        ],
      ),
    );
  }
}
