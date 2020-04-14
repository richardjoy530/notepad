import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/addnote.dart';

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
  final List<Tab> myTabs = <Tab>[
    Tab(
      //text: 'Categories',
      icon: Icon(
        Icons.category,
        color: Colors.redAccent,
      ),
    ),
    Tab(
      //text: 'Notes',
      icon: Icon(
        Icons.note,
        color: Colors.redAccent,
      ),
    ),
    Tab(
      //text: 'Starred',
      icon: Icon(
        Icons.star_half,
        color: Colors.redAccent,
      ),
    ),
  ];

  TabController _tabController;
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
    super.dispose();
  }

  void _onMenuPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Column(
          //mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(150.0, 10, 150, 10),
              child: Divider(
                color: Colors.grey[500],
                thickness: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                //color: Colors.grey[800],
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: AssetImage('images/avatar.png')),
                  title: Text(
                    'Hello,',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Richard',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey[500],
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.color_lens,
                  color: Colors.grey[500],
                ),
                title: Text(
                  'Switch Theme',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.colorize,
                  color: Colors.grey[500],
                ),
                title: Text(
                  'Change Accent Color',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.g_translate,
                  color: Colors.grey[500],
                ),
                title: Text(
                  'Help Translate',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.supervisor_account,
                  color: Colors.grey[500],
                ),
                title: Text(
                  'Support Development',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.rate_review,
                  color: Colors.grey[500],
                ),
                title: Text(
                  'Rate and Review',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: Colors.grey[500],
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          _tabController.index == 0
              ? 'Catagories'
              : _tabController.index == 1 ? 'Notes' : 'Starred',
          style: TextStyle(
            fontFamily: 'SpaceMono',
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 6,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: 25,
            color: Colors.grey[500],
          ),
          onPressed: () {
            setState(() {
              print('pressed');
              _onMenuPressed();
            });
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
            child: IconButton(
              icon: Icon(
                Icons.cloud_queue,
                size: 25,
                color: Colors.grey[500],
              ),
              onPressed: () {},
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          tabs: <Widget>[
            Tab(
              //text: 'Categories',
              icon: Icon(
                Icons.category,
                color: Colors.grey[500],
              ),
            ),
            Tab(
              //text: 'Notes',
              icon: Icon(
                Icons.note,
                color: Colors.grey[500],
              ),
            ),
            Tab(
              //text: 'Starred',
              icon: Icon(
                Icons.star_half,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Tab(
            icon: Icon(
              Icons.category,
              color: Colors.redAccent,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.home,
              color: Colors.redAccent,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.star,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8.0, 15, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: '123',
              onPressed: () {},
              label: Text('Category'),
              icon: Icon(Icons.add),
              backgroundColor: Colors.redAccent,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNote()),
                );
              },
              label: Text('Note'),
              backgroundColor: Colors.redAccent,
              icon: Icon(Icons.add),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
