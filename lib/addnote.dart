import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  List<bool> iconState = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.grey[500],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info, color: Colors.grey[500]), onPressed: null),
          IconButton(
              icon: Icon(Icons.check_circle, color: Colors.redAccent),
              onPressed: () {
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
                  maxLength: 25,
                  style: TextStyle(
                    fontFamily: 'SpaceMono',
                    color: Colors.grey[500],
                    fontSize: 25,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      fontFamily: 'SpaceMono',
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      fontFamily: 'SpaceMono',
                      color: Colors.grey[500],
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 20,
                  style: TextStyle(
                    fontFamily: 'SpaceMono',
                    color: Colors.grey[700],
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a Note',
                    hintStyle: TextStyle(
                      fontFamily: 'SpaceMono',
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
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
                    color: Colors.grey[500],
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
