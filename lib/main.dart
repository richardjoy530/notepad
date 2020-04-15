import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/addnote.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'SpaceMono'), home: MyTabbedHome());
  }
}

class MyTabbedHome extends StatefulWidget {
  @override
  _MyTabbedHomeState createState() => _MyTabbedHomeState();
}

class _MyTabbedHomeState extends State<MyTabbedHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController controller = TextEditingController();
  List<Note> _notes;
  List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.category)),
    Tab(icon: Icon(Icons.note)),
    Tab(icon: Icon(Icons.star_half))
  ];
  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onMenuPressed() {
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
                  _onMenuPressed();
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
          child: ListView.builder(itemBuilder: (context, index) {
            return Center(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.album),
                  title: Text(_notes[index].title),
                  subtitle: Text(_notes[index].text),
                ),
              ),
            );
          }),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNote()),
                  );
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

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}

class Note {
  final String title;
  final String text;

  Note(this.title, this.text);

  Note.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        text = json['text'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'text': text,
      };
}

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  List<bool> iconState = [false, false, false, false];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
