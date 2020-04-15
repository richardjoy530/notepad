import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/addnote.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'SpaceMono'),
        home: MyTabbedHome(
          storage: Storage(),
        ));
  }
}

class MyTabbedHome extends StatefulWidget {
  final Storage storage;

  MyTabbedHome({@required this.storage});

  @override
  _MyTabbedHomeState createState() => _MyTabbedHomeState();
}

class _MyTabbedHomeState extends State<MyTabbedHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController controller = TextEditingController();
  String state;
  Future<Directory> _appDocDir;
  List<ListTile> noteItems = <ListTile>[
    ListTile(leading: Icon(Icons.fiber_manual_record), title: Text('Note 1')),
    ListTile(leading: Icon(Icons.fiber_manual_record), title: Text('Note 2')),
    ListTile(leading: Icon(Icons.fiber_manual_record), title: Text('Note 3')),
    ListTile(leading: Icon(Icons.fiber_manual_record), title: Text('Note 4')),
    ListTile(leading: Icon(Icons.fiber_manual_record), title: Text('Note 5')),
    ListTile(leading: Icon(Icons.fiber_manual_record), title: Text('Note 6')),
    ListTile(leading: Icon(Icons.fiber_manual_record), title: Text('Note 7'))
  ];
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
    widget.storage.readData().then((String value) {
      setState(() {
        state = value;
      });
    });
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
          child: Column(
            children: noteItems,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNote(
                              storage: Storage(),
                            )),
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
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;

      // Read the file.
      String body = await file.readAsString();

      return body;
    } catch (e) {
      // If encountering an error, return 0.
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    // Write the file.
    return file.writeAsString("$data");
  }
}

class NoteItem {
  String title;
  String body;

  NoteItem(String title, String body) {
    this.title = title;
    this.body = body;
  }
}
