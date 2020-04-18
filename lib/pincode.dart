import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/main.dart';

class PinCode extends StatefulWidget {
  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  void navigateToHome(BuildContext context) async {
    bool result = await Navigator.push(
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
            'Password',
            style: TextStyle(
                fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: TextField(
              onSubmitted: (value) {
                navigateToHome(context);
              },
              maxLength: 5,
              obscureText: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                semanticCounterText: '',
                hintText: 'Password',
                border: InputBorder.none,
              ),
            ),
          )
        ],
      )),
    );
  }
}
