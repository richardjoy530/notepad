import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notepad/main.dart';

class AddNote extends StatefulWidget {
  final Storage storage;

  AddNote({@required this.storage});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  List<bool> iconState = [false, false, false, false];
  TextEditingController controller = TextEditingController();
  String state;
  Future<Directory> _appDocDir;

  @override
  void initState() {
    super.initState();
    widget.storage.readData().then((String value) {
      setState(() {
        state = value;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<File> writeData() async {
    setState(() {
      state = controller.text;
      controller.text = '';
    });
    return widget.storage.writeData(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.info), onPressed: null),
          IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () {
                writeData();
                Navigator.pop(context);
              }),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  maxLength: 25,
                  style: TextStyle(fontSize: 25),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(fontSize: 5),
                    hintText: 'Title',
                    hintStyle: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  //controller: controller,
                  maxLines: 20,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a Note',
                    hintStyle: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.notifications_active,
                          color: iconState[0] == false
                              ? Colors.grey[500]
                              : Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          iconState[0] = !iconState[0];
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.star,
                          color: iconState[1] == false
                              ? Colors.grey[500]
                              : Colors.yellowAccent),
                      onPressed: () {
                        setState(() {
                          iconState[1] = !iconState[1];
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.category,
                          color: iconState[2] == false
                              ? Colors.grey[500]
                              : Colors.blueAccent),
                      onPressed: () {
                        setState(() {
                          iconState[2] = !iconState[2];
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.list,
                          color: iconState[3] == false
                              ? Colors.grey[500]
                              : Colors.greenAccent),
                      onPressed: () {
                        setState(() {
                          iconState[3] = !iconState[3];
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
