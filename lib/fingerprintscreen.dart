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
  Future<bool> authenticated;

  Future<bool> _authenticate() async {
    bool result = false;
    try {
      setState(() {});
      result = await auth.authenticateWithBiometrics(
          localizedReason: 'Verify Your identity');
      setState(() {});
    } on PlatformException catch (e) {
      print(e);
    }
    return result;
  }

  @override
  void initState() {
    authenticated = _authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authenticated,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return snapshot.data ? MyTabbedHome() : FingerPrintListener();
          } else {
            throw CircularProgressIndicator(); //you should handle this case if your function returns null
          }
        } else {
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
//  Future<bool> authenticated;
//  final LocalAuthentication auth = LocalAuthentication();
//  Future<bool> _authenticate() async {
//    bool result = false;
//    try {
//      setState(() {});
//      result = await auth.authenticateWithBiometrics(
//          localizedReason: 'Verify Your identity');
//      setState(() {});
//    } on PlatformException catch (e) {
//      print(e);
//    }
//    return result;
//  }

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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Place your fingertip on the fingerprint sensor to verify your identity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            Icons.fingerprint,
            size: 70,
            color: Colors.blueGrey,
          ),
//          RaisedButton(
//              child: Text('Verify'),
//              onPressed: () {
//                _authenticate();
//              })
        ],
      ),
    );
  }
}
