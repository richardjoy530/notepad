import 'dart:async';
import 'package:notepad/note.dart';
import 'package:notepad/main.dart';
import 'package:notepad/helper.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  AddNote(this.note, this.appBarTitle);
  @override
  AddNoteState createState() => AddNoteState(appBarTitle, note);
}

class AddNoteState extends State<AddNote> {
  List<Category> category = [];
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  AddNoteState(this.appBarTitle, this.note);

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
    Navigator.pop(context, true);
    if (note.id != null) {
      print(["calling updatenote "]);
      await helper.updateNote(note);
    } else {
      print(["calling insert "]);
      await helper.insertNote(note);
    }
  }

  Future<void> showCategories(context, Note note) async {
    var itemIndex;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            'Select a Category',
            style: TextStyle(color: Colors.redAccent),
          ),
          children: <Widget>[
            Column(
              children: List.generate(
                category.length,
                    (index) {
                  return SimpleDialogOption(
                    child: ListTile(
                      leading: Icon(Icons.label_outline),
                      title: Text(category[index].name),
                    ),
                    onPressed: () {
                      itemIndex = index;
                      note.category = category[index].name;
                      Navigator.pop(context, category[index].name);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    print(category[itemIndex]);
  }

  void _delete(BuildContext context) async {
    print(['In _delete() ', note.id, note.title]);
    await helper.deleteNote(note.id);
    Navigator.pop(context, true);
    if (note.id == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(["In build AddNote title = ", note.title, note.id]);
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
                //note.starred =
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
                    note.title = titleController.text;
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
                            color: iconState[2] == false
                                ? Colors.grey[500]
                                : Colors.blueAccent),
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
                        print("pressed delete");
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
