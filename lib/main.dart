import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:notepad/helper.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'SpaceMono',
        ),
        home: MyTabbedHome());
  }
}

class MyTabbedHome extends StatefulWidget {
  @override
  _MyTabbedHomeState createState() => _MyTabbedHomeState();
}

class _MyTabbedHomeState extends State<MyTabbedHome>
    with SingleTickerProviderStateMixin {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TabController _tabController;
  TextEditingController controller = TextEditingController();
  List<Note> notes = [];
  List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.category)),
    Tab(icon: Icon(Icons.home)),
    Tab(icon: Icon(Icons.star_half))
  ];

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateListView();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  void updateListView() {
    print("Updating");
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.notes = noteList;
        });
        print([
          "in updatelistview id of 5th index = ",
          notes[5].id,
          notes[5]._id
        ]);
      });
    });
  } //

  void navigateToDetail(BuildContext context, Note note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddNote(note, title);
        },
      ),
    );

    if (result == true) {
      updateListView();
    }
  }

  void _onMenuPressed(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        builder: (context) {
          return Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(150.0, 10, 150, 10),
                  child: Divider(thickness: 2)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: AssetImage('images/avatar.png')),
                      title: Text('Hello,'),
                      subtitle: Text('Richard')),
                ),
              ),
              Expanded(
                child: ListTile(
                    leading: Icon(Icons.settings), title: Text('Settings')),
              ),
              Expanded(
                child: ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Text('Switch Theme')),
              ),
              Expanded(
                child: ListTile(
                    leading: Icon(Icons.colorize),
                    title: Text('Change Accent Color')),
              ),
              Expanded(
                child: ListTile(
                    leading: Icon(Icons.g_translate),
                    title: Text('Help Translate')),
              ),
              Expanded(
                child: ListTile(
                    leading: Icon(Icons.supervisor_account),
                    title: Text('Support Development')),
              ),
              Expanded(
                child: ListTile(
                    leading: Icon(Icons.rate_review),
                    title: Text('Rate and Review')),
              ),
              Expanded(
                child: ListTile(
                    leading: Icon(Icons.info_outline), title: Text('About')),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (notes == null) {
      notes = List<Note>();
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(
              _tabController.index == 0
                  ? 'Catagories'
                  : _tabController.index == 1 ? 'Notes' : 'Starred',
              style: TextStyle(
                  fontFamily: 'SpaceMono', fontSize: 20, letterSpacing: 6)),
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  print('pressed');
                  _onMenuPressed(context);
                });
              }),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                child:
                    IconButton(icon: Icon(Icons.cloud_queue), onPressed: () {}))
          ],
          bottom: TabBar(controller: _tabController, tabs: myTabs)),
      body: TabBarView(controller: _tabController, children: <Widget>[
        Tab(icon: Icon(Icons.home)),
        Tab(
          child: notes.length == 0
              ? IconButton(
                  icon: Icon(Icons.note_add),
                  onPressed: () {
                    navigateToDetail(context, Note('', ''), 'Add Note');
                  },
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Center(
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            navigateToDetail(
                                context, notes[index], 'Edit Note');
                          },
                          //leading: Icon(Icons.album),
                          title: Text(notes[index].title),
                          subtitle: Text(notes[index].text),
                        ),
                      ),
                    );
                  },
                  itemCount: notes.length,
                ),
        ),
        Tab(icon: Icon(Icons.star)),
      ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8.0, 15, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
                heroTag: 'hero1',
                onPressed: () {},
                label: Text('Category'),
                icon: Icon(Icons.add)),
            FloatingActionButton.extended(
                onPressed: () {
                  navigateToDetail(context, Note('', ''), 'Add Note');
                },
                label: Text('Note'),
                icon: Icon(Icons.add))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AddNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  AddNote(this.note, this.appBarTitle);
  @override
  AddNoteState createState() => AddNoteState(appBarTitle, note);
}

class AddNoteState extends State<AddNote> {
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
                  style: TextStyle(fontSize: 25),
                  onChanged: (value) {
                    note.title = titleController.text;
                  },
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
                  controller: textController,
                  maxLines: 20,
                  style: TextStyle(fontSize: 20),
                  onChanged: (value) {
                    note.title = titleController.text;
                  },
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
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
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

class Note {
  int _id;
  String _title;
  String _text;

  Note(this._title, this._text);
  Note.withId(this._id, this._title, this._text);

  int get id => _id;
  String get title => _title;
  String get text => _text;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set text(String newDescription) {
    if (newDescription.length <= 255) {
      this._text = newDescription;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    print(["in toMap id = ", id, ' _id = ', _id]);
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['text'] = _text;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    print(["in fromMap map['id'] = ", map['id']]);

    this._id = map['id'];
    this._title = map['title'];
    this._text = map['text'];
  }
}
