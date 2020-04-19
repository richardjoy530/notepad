import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeSet extends StatefulWidget {
  @override
  _PinCodeSetState createState() => _PinCodeSetState();
}

class _PinCodeSetState extends State<PinCodeSet> {
  TextEditingController textController = TextEditingController();

  void setPin(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pin', value);
    prefs.setBool('pinEnable', true);
  }

  void navigateToHome(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyTabbedHome();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Enter Your',
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'PIN',
            style: TextStyle(
                fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: textController,
            onSubmitted: (value) {
              navigateToHome(context);
            },
            onChanged: (value) {
              setPin(value);
            },
            maxLength: 5,
            obscureText: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
              counterText: '',
              //counterStyle: TextStyle(color: Colors.grey[900]),
              hintText: '...',
              border: InputBorder.none,
            ),
          )
        ],
      )),
    );
  }
}
