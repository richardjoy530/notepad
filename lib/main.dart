import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notepad/addcategory.dart';
import 'package:notepad/addnote.dart';
import 'package:notepad/categorydisplay.dart';
import 'package:notepad/fingerprintscreen.dart';
import 'package:notepad/helper.dart';
import 'package:notepad/note.dart';
import 'package:notepad/pincode.dart';
import 'package:notepad/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Color titleColor = Colors.white;
Color textColor = Colors.grey[500];

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<int> pinEnable;
  PinData pinData = PinData();
  @override
  void initState() {
    updatePinEnable();
    super.initState();
  }

  Future<void> updatePinEnable() async {
    pinEnable = pinData.getPinEnable();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionColor: Colors.grey[900],
        primaryColor: Colors.grey[900],
        accentColor: Colors.redAccent,
        //iconTheme: IconThemeData(color: Colors.redAccent),
        primaryIconTheme: IconThemeData(color: Colors.grey[500]),
        canvasColor: Colors.grey[900],
        textTheme: TextTheme(title: TextStyle(color: Colors.white)),
        cardTheme: CardTheme(color: Colors.grey[800]),
        fontFamily: 'SpaceMono',
      ),
      home: FutureBuilder<int>(
          future: pinEnable,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return snapshot.data == 0
                    ? MyTabbedHome()
                    : snapshot.data == 1 ? PinCode() : FingerPrintListener();
              } else {
                throw Exception(); //you should handle this case if your function returns null
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class MyTabbedHome extends StatefulWidget {
  @override
  _MyTabbedHomeState createState() => _MyTabbedHomeState();
}

class _MyTabbedHomeState extends State<MyTabbedHome>
    with SingleTickerProviderStateMixin {
  int textLimiter;
  DatabaseHelper databaseHelper = DatabaseHelper();
  TabController _tabController;
  ScrollController _scrollController;
  int pinEnable;
  PinData pinData = PinData();
  List<Note> notes = [];
  List<Category> categoryList = [];
  List<String> categoryNameList = [];
  Category newCategory;
  List<Note> starredNotes = [];
  List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.category)),
    Tab(icon: Icon(Icons.home)),
    Tab(icon: Icon(Icons.star_half))
  ];
  List<String> menu = [
    'Settings',
    'Switch Theme',
    'Change Accent Color',
    'Help Translate',
    'Support Development',
    'Rate and Review',
    'About'
  ];

  Future<void> updatePinEnable() async {
    pinData.getPinEnable().then((onValue) {
      pinEnable = onValue;
    });
  }

  //Updates the CategoryList from CategoryNameList
  updateCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    categoryNameList =
        (prefs.getStringList('categoryNameList') ?? ['Not Specified']);
    for (var name in categoryNameList) {
      var color = await getCategoryColor(name);
      setState(() {
        categoryList.add(Category(name, color: color));
      });
    }
  }

  //Gets Color values from the Color String
  Future<Color> getCategoryColor(String name) async {
    var colorName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      colorName = (prefs.getString(name) ?? 'blue');
    });
    switch (colorName) {
      case 'red':
        return Colors.redAccent;
      case 'blue':
        return Colors.blueAccent;
      case 'yellow':
        return Colors.yellowAccent;
      case 'green':
        return Colors.greenAccent;
      case 'lightgreen':
        return Colors.lightGreenAccent;
      case 'purple':
        return Colors.purpleAccent;
      case 'pink':
        return Colors.pinkAccent;
      case 'cyan':
        return Colors.cyanAccent;
    }
    return Colors.blueAccent;
  }

  Future<void> addCategoryNameColor(String name, Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, getStringColor(color));
  }

  String getStringColor(Color color) {
    if (color == Colors.redAccent) {
      return 'red';
    }
    if (color == Colors.blueAccent) {
      return 'blue';
    }
    if (color == Colors.yellowAccent) {
      return 'yellow';
    }
    if (color == Colors.greenAccent) {
      return 'green';
    }
    if (color == Colors.lightGreenAccent) {
      return 'lightgreen';
    }
    if (color == Colors.purpleAccent) {
      return 'purple';
    }
    if (color == Colors.pinkAccent) {
      return 'pink';
    }
    if (color == Colors.cyanAccent) {
      return 'cyan';
    } else {
      return 'blue';
    }
  }

  //TextLimiters
  Future<void> getTextLimiter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    textLimiter = (prefs.getInt('textlimiter') ?? 2);
  }

  Future<void> setTextLimiter(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('textLimiter', value);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void updateListView() {
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
                          radius: 25,
                          backgroundImage: AssetImage('images/avatar.png')),
                      title:
                      Text('Hello,', style: TextStyle(color: Colors.white)),
                      subtitle: Text('Humans',
                          style: TextStyle(color: Colors.grey[500]))),
                ),
              ),
              ListTile(
                  onTap: () {
                    navigateToSettings(context);
                  },
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

  navigateToSettings(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Settings(pinEnable, textLimiter);
        },
      ),
    );

    if (result != 'reset') {
      setTextLimiter(result);
      updateListView();
      updatePinEnable();
    } else {
      setState(() {
        categoryList = [Category('Not Specified')];
        notes = [];
      });
    }
  }

  navigateToCategoryAdd(BuildContext context) async {
    newCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddCategory();
        },
      ),
    );
    if (newCategory != null) {
      categoryList.add(newCategory);
      categoryNameList.add(newCategory.name);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('categoryNameList', categoryNameList);
      addCategoryNameColor(newCategory.name, newCategory.color);
      updateListView();
    }
  }

  navigateToCategoryDisplay(BuildContext context, Category category) async {
    var deleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CategoryDisplay(
            openCategory: category,
            notes: notes,
            categoryList: categoryList,
          );
        },
      ),
    );

    if (deleted == 'deleted') {
      setState(() {
        categoryList.remove(category);
        categoryNameList.remove(category.name);
      });
    }
  }

  navigateToAddNote(BuildContext context, Note note, String title) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddNote(note, title, categoryList);
        },
      ),
    );

    updateListView();
  }

  @override
  void initState() {
    super.initState();
    getTextLimiter();
    updatePinEnable();
    updateListView();
    updateCategoryList();
    _scrollController = ScrollController();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (notes == null) {
      notes = List<Note>();
    }
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, bool isBoxScrolled) {
          return <Widget>[
            SliverAppBar(
                pinned: true,
                floating: true,
                forceElevated: isBoxScrolled,
                title: Text(
                    _tabController.index == 0
                        ? 'Catagories'
                        : _tabController.index == 1 ? 'Notes' : 'Starred',
                    style: TextStyle(
                        fontFamily: 'SpaceMono',
                        fontSize: 20,
                        letterSpacing: 6)),
                leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        _onMenuPressed(context);
                      });
                    }),
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                      child: IconButton(
                          icon: Icon(Icons.cloud_queue), onPressed: () {}))
                ],
                bottom: TabBar(
                  controller: _tabController,
                  tabs: myTabs,
                ))
          ];
        },
        body: TabBarView(controller: _tabController, children: <Widget>[
          Tab(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Color.fromRGBO(20, 20, 20, 0.5),
                            child: Center(
                              child: ListTile(
                                onTap: () {
                                  navigateToCategoryDisplay(
                                      context, categoryList[index]);
                                },
                                leading: Icon(
                                  Icons.label_outline,
                                  color: categoryList[index].color,
                                ),
                                title: Text(
                                  categoryList[index].name,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: categoryList.length,
                  ))
                ],
              ),
            ),
          ),
          Tab(
            child: notes.length == 0
                ? IconButton(
                    icon: Icon(Icons.note_add),
                    onPressed: () {
                      navigateToAddNote(context,
                          Note('', '', Category('Not Specified')), 'Add Note');
                    },
                  )
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Color.fromRGBO(20, 20, 20, 0.5),
                                  child: ListTile(
                                    onTap: () {
                                      print([
                                        notes[index].title,
                                        notes[index].category.name,
                                        notes[index].category.color
                                      ]);
                                      navigateToAddNote(
                                          context, notes[index], 'Edit Note');
                                    },
                                    //leading: Icon(Icons.album),
                                    title: Text(
                                      notes[index].title,
                                      style: TextStyle(color: titleColor),
                                    ),
                                    subtitle: Text(
                                      notes[index].text,
                                      maxLines: textLimiter,
                                      style: TextStyle(
                                          color: notes[index].category.color),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: notes.length,
                        ),
                      ),
                    ],
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Color.fromRGBO(20, 20, 20, 0.5),
                            child: ListTile(
                              onTap: () {
                                print([
                                  notes[index].title,
                                  notes[index].category.name,
                                  notes[index].category.color
                                ]);
                                navigateToAddNote(
                                    context, notes[starIndex], 'Edit Note');
                              },
                              leading:
                                  Icon(Icons.star, color: Colors.yellow[800]),
                              title: Text(
                                starredNotes[starIndex].title,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(starredNotes[starIndex].text,
                                  maxLines: textLimiter,
                                  style: TextStyle(color: Colors.grey[500])),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: starredNotes.length,
                  ),
          ),
        ]),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8.0, 15, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
                heroTag: 'hero1',
                onPressed: () {
                  navigateToCategoryAdd(context);
                },
                label: Text('Category'),
                icon: Icon(Icons.add)),
            FloatingActionButton.extended(
                onPressed: () {
                  navigateToAddNote(context,
                      Note('', '', Category('Not Specified')), 'Add Note');
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
