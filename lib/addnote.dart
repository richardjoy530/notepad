import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notepad/helper.dart';
import 'package:notepad/main.dart';
import 'package:notepad/note.dart';

class AddNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  final List<Category> category;

  AddNote(this.note, this.appBarTitle, this.category);
  @override
  AddNoteState createState() => AddNoteState(appBarTitle, note, category);
}

class AddNoteState extends State<AddNote> {
  List<Category> category = [];
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  AddNoteState(this.appBarTitle, this.note, this.category);
  List<bool> iconState = [false, false, false, false];
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    super.dispose();
  }

  void _save(BuildContext context) async {
    if (note.id != null) {
      await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
    Navigator.pop(context);
  }

  Future<void> showCategories(context, Note note) async {
    var itemIndex;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.grey[900],
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            'Select a Category',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                category.length,
                    (index) {
                  return SimpleDialogOption(
                    child: ListTile(
                      leading: Icon(
                        Icons.label_outline,
                        color: category[index].color,
                      ),
                      title: Text(category[index].name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () {
                      itemIndex = index;
                      setState(() {
                        note.category.name = category[index].name;
                        note.category.color = category[index].color;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _delete(BuildContext context) async {
    await helper.deleteNote(note.id);
    Navigator.pop(context, true);
    if (note.id == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    textController.text = note.text;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: <Widget>[
          //TODO: Note info ie note statistics:- creation date, Category, word count, character count
          IconButton(icon: Icon(Icons.info), onPressed: null),
          IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () {
                note.title = titleController.text;
                note.text = textController.text;
                _save(context);
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
                  controller: titleController,
                  maxLength: 25,
                  style: TextStyle(fontSize: 25, color: titleColor),
                  onChanged: (value) {
                    note.title = titleController.text;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(fontSize: 5),
                    hintText: 'Title',
                    hintStyle: TextStyle(fontSize: 25, color: textColor),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: TextField(
                  controller: textController,
                  maxLines: 10,
                  style: TextStyle(fontSize: 20, color: textColor),
                  onChanged: (value) {
                    note.text = textController.text;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a Note',
                    hintStyle: TextStyle(fontSize: 20, color: textColor),
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
                          color: note.starred == 0
                              ? Colors.grey[500]
                              : Colors.yellow[800]),
                      onPressed: () {
                        setState(() {
                          note.title = titleController.text;
                          note.text = textController.text;
                          note.starred == 0
                              ? note.starred = 1
                              : note.starred = 0;
                          note.starred == 0
                              ? iconState[1] = false
                              : iconState[1] = true;
                        });
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.category,
                            //TODO change color dynamically
                            color: note.category.color),
                        onPressed: () {
                          setState(() {
                            showCategories(context, note);
                          });
                        }),
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
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        _delete(context);
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
