import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/note.dart';

class PinCodeSet extends StatefulWidget {
  final String oldPin;

  const PinCodeSet({Key key, this.oldPin}) : super(key: key);
  @override
  _PinCodeSetState createState() => _PinCodeSetState();
}

class _PinCodeSetState extends State<PinCodeSet> {
  PinData pinData = PinData();
  bool pinChange = false;
  TextEditingController textController;
  TextEditingController oldPinController;

  @override
  void dispose() {
    textController.dispose();
    oldPinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    textController = TextEditingController();
    oldPinController = TextEditingController();
    super.initState();
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
          widget.oldPin == ''
              ? Divider()
              : Column(
                  children: <Widget>[
                    Text(
                      'Verify Your',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Old Pin',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: oldPinController,
                      onChanged: (value) {
                        if (widget.oldPin == value) {
                          pinChange = true;
                        }
                      },
                      onSubmitted: (value) {
                        if (widget.oldPin == value) {
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
                  ],
                ),
          Text(
            'Enter Your',
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'New Pin',
            style: TextStyle(
                fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: textController,
            onChanged: (value) {
              if (textController.text != '' &&
                  textController.text.length == 4 &&
                  (pinChange == true || widget.oldPin == '')) {
                pinData.setPin(textController.text);
                pinData.setPinEnable(1);
                Navigator.pop(context, true);
              }
            },
            onSubmitted: (value) {
              if (textController.text != '' &&
                  (pinChange == true || widget.oldPin == '')) {
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
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
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
