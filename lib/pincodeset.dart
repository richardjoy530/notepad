import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/note.dart';

class PinCodeSet extends StatefulWidget {
  @override
  _PinCodeSetState createState() => _PinCodeSetState();
}

class _PinCodeSetState extends State<PinCodeSet> {
  PinData pinData = PinData();
  String oldPin;
  bool pinChange = false;
  TextEditingController textController = TextEditingController();
  TextEditingController oldPinController = TextEditingController();

  @override
  void initState() {
    updatePinEnable();
    super.initState();
  }

  Future<void> updatePinEnable() async {
    pinData.getPin().then((onValue) {
      oldPin = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Your PIN"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (textController.text != '' && pinChange == true) {
                pinData.setPin(textController.text);
                pinData.setPinEnable(1);
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
                'Verify Your',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'OLD PIN',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Leave it empty if it\'s your first PIN',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: oldPinController,
                onChanged: (value) {
                  if (oldPin == value) {
                    pinChange = true;
                  }
                },
                onSubmitted: (value) {
                  if (oldPin == value) {
                    pinChange = true;
                  }
                },
                maxLength: 4,
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
                  hintText: '...',
                  border: InputBorder.none,
                ),
              ),
              Text(
                'Enter Your',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'NEW PIN',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: textController,
                onSubmitted: (value) {
                  if (textController.text != '' &&
                      (pinChange == true || oldPin == '')) {
                    pinData.setPin(textController.text);
                    pinData.setPinEnable(1);
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
                  hintText: '...',
                  border: InputBorder.none,
                ),
              )
            ],
          )),
    );
  }
}
