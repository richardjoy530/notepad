import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/note.dart';

class PinCodeSet extends StatefulWidget {
  @override
  _PinCodeSetState createState() => _PinCodeSetState();
}

class _PinCodeSetState extends State<PinCodeSet> {
  PinData pinData = PinData();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Your PIN"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (textController.text != null) {
                pinData.setPin(textController.text);
                pinData.setPinEnable(true);
                Navigator.pop(context, true);
              }
            },
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter Your',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'PIN',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: textController,
                onSubmitted: (value) {
                  if (textController.text != null) {
                    pinData.setPin(textController.text);
                    pinData.setPinEnable(true);
                    Navigator.pop(context, true);
                  }
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
