import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:notepad/helper.dart';
import 'dart:async';

Color titleColor = Colors.white;
Color textColor = Colors.grey[500];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.grey[900],
          accentColor: Colors.redAccent,
          //iconTheme: IconThemeData(color: Colors.redAccent),
          primaryIconTheme: IconThemeData(color: Colors.grey[500]),
          canvasColor: Colors.grey[900],
          textTheme: TextTheme(title: TextStyle(color: Colors.white)),
          cardTheme: CardTheme(color: Colors.grey[800]),
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
  List<Note> starredNotes = [];
  List<String> menu = [
    'Settings',
    'Switch Theme',
    'Change Accent Color',
    'Help Translate',
    'Support Development',
    'Rate and Review',
    'About'
  ];
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
          starredNotes = [];
          for (var i = 0; i < notes.length; i++) {
            notes[i].starred == 1 ? starredNotes.add(notes[i]) : print(" ");
          }
        });
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
    updateListView();
    if (result == true) {
      updateListView();
    }
  }

  void _onMenuPressed(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        builder: (context) {
          return Wrap(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(200.0, 10, 200, 10),
                  child: Divider(thickness: 2, color: Colors.grey[500])),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: AssetImage('images/avatar.png')),
                      title:
                          Text('Hello,', style: TextStyle(color: Colors.white)),
                      subtitle: Text('Richard',
                          style: TextStyle(color: Colors.grey[500]))),
                ),
              ),
              ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.grey[500],
                  ),
                  title: Text('Settings', style: TextStyle(color: titleColor))),
              ListTile(
                  leading: Icon(
                    Icons.color_lens,
                    color: Colors.grey[500],
                  ),
                  title: Text('Switch Theme',
                      style: TextStyle(color: titleColor))),
              ListTile(
                  leading: Icon(
                    Icons.colorize,
                    color: Colors.grey[500],
                  ),
                  title: Text('Change Accent Color',
                      style: TextStyle(color: titleColor))),
              ListTile(
                  leading: Icon(
                    Icons.g_translate,
                    color: Colors.grey[500],
                  ),
                  title: Text('Help Translate',
                      style: TextStyle(color: titleColor))),
              ListTile(
                  leading: Icon(
                    Icons.supervisor_account,
                    color: Colors.grey[500],
                  ),
                  title: Text('Support Development',
                      style: TextStyle(color: titleColor))),
              ListTile(
                  leading: Icon(
                    Icons.rate_review,
                    color: Colors.grey[500],
                  ),
                  title: Text('Rate and Review',
                      style: TextStyle(color: titleColor))),
              ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.grey[500],
                  ),
                  title: Text('About', style: TextStyle(color: titleColor))),
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
                    navigateToDetail(
                        context, Note('', '', 'Not Specified'), 'Add Note');
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
                          title: Text(
                            notes[index].title,
                            style: TextStyle(color: titleColor),
                          ),
                          subtitle: Text(
                            notes[index].text,
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: notes.length,
                ),
        ),
        Tab(
          child: starredNotes.length == 0
              ? Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                )
              : ListView.builder(
                  itemBuilder: (context, starIndex) {
                    return Center(
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.star, color: Colors.yellow[800]),
                          title: Text(
                            starredNotes[starIndex].title,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(starredNotes[starIndex].text,
                              style: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                    );
                  },
                  itemCount: starredNotes.length,
                ),
        ),
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
                  navigateToDetail(
                      context, Note('', '', 'Not Specified'), 'Add Note');
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
  List<String> category = ['Not Specified', 'Sooper Sanams'];
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

  Future<void> showCategories() async {
    switch (await showDialog(
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
              ListView.builder(itemBuilder: (context, categoryListIndex) {
                return SimpleDialogOption(
                  child: ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text(category[categoryListIndex]),
                  ),
                  onPressed: () {
                    Navigator.pop(context, category[categoryListIndex]);
                  },
                );
              }),
            ],
          );
        })) {
      case 'Not Specified':
        print('Option 1');
        break;
      case 'Cats':
        print('Option 2');
        break;
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
                  maxLines: 20,
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
                            showCategories();
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

class Note {
  int id;
  int starred;
  String title;
  String text;
  String category;

  Note(this.title, this.text, this.category, {this.starred = 0});

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    print(["in toMap id = ", id]);
    if (id != null) {
      map['id'] = id;
    }
    map['starred'] = starred;
    map['title'] = title;
    map['text'] = text;
    map['category'] = category;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    print(["in fromMap map['id'] = ", map['id']]);

    this.id = map['id'];
    this.starred = map['starred'];
    this.title = map['title'];
    this.text = map['text'];
    this.category = map['category'];
  }
}
