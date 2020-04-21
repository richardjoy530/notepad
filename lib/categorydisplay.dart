import 'package:flutter/material.dart';
import 'package:notepad/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addnote.dart';

Color titleColor = Colors.white;
Color textColor = Colors.grey[500];

class CategoryDisplay extends StatefulWidget {
  final List<Category> categoryList;
  final Category openCategory;
  final List<Note> notes;

  CategoryDisplay({Key key, this.openCategory, this.notes, this.categoryList})
      : super(key: key);

  @override
  _CategoryDisplayState createState() => _CategoryDisplayState();
}

class _CategoryDisplayState extends State<CategoryDisplay> {
  List<Note> categorisedNote = [];

  @override
  void initState() {
    getCategorisedNotes();
    super.initState();
  }

  void navigateToAddNote(BuildContext context, Note note, String title) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddNote(note, title, widget.categoryList);
        },
      ),
    );
  }

  void getCategorisedNotes() {
    for (var i = 0; i < widget.notes.length; i++) {
      widget.notes[i].category.name == widget.openCategory.name
          ? categorisedNote.add(widget.notes[i])
          : print(" ");
    }
  }

  Future<void> deleteCategory() async {
    if (widget.openCategory.name != 'Not Specified') {
      for (var deleteNote in categorisedNote) {
        deleteNote.category.name = 'Not Specified';
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var tempList = prefs.getStringList('categoryNameList');
      tempList.remove(widget.openCategory.name);
      prefs.setStringList('categoryNameList', tempList);
      prefs.remove(widget.openCategory.name);
      Navigator.pop(context, 'deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              widget.openCategory.name,
              style: TextStyle(
                  color: widget.openCategory.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.grey[400]),
                onPressed: () {
                  deleteCategory();
                }),
          ),
          categorisedNote.length == 0
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(8, 50, 8, 50),
                  child: Center(
                      child: Text(
                    'No notes in this category',
                    style: TextStyle(color: titleColor, fontSize: 20),
                  )),
                )
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Card(
                            color: Color.fromRGBO(20, 20, 20, 0.5),
                            child: ListTile(
                              onTap: () {
                                navigateToAddNote(context,
                                    categorisedNote[index], 'Edit Note');
                              },
                              title: Text(
                                categorisedNote[index].title,
                                style: TextStyle(color: titleColor),
                              ),
                              subtitle: Text(
                                categorisedNote[index].text,
                                maxLines: 3,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: categorisedNote.length,
                  ),
                ),
        ],
      ),
    ));
  }
}
