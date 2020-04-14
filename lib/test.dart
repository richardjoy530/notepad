import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyTabbedHome());

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
        color: Colors.pinkAccent[400],
      ),
    ),
    Tab(
      //text: 'Notes',
      icon: Icon(
        Icons.note,
        color: Colors.pinkAccent[400],
      ),
    ),
    Tab(
      //text: 'Starred',
      icon: Icon(
        Icons.star_half,
        color: Colors.pinkAccent[400],
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.ac_unit),
              title: Text('Cooling'),
            ),
            ListTile(
              leading: Icon(Icons.accessibility_new),
              title: Text('People'),
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('Stats'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SpaceMono',
      ),
      home: Scaffold(
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
              size: 30,
              color: Colors.grey[500],
            ),
            onPressed: () {
              setState(() {
                print('pressed');
                //_onMenuPressed();
              });
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.cloud_queue,
                size: 30,
                color: Colors.grey[500],
              ),
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.pinkAccent[400],
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
                color: Colors.pinkAccent[400],
              ),
            ),
            Tab(
              icon: Icon(
                Icons.home,
                color: Colors.pinkAccent[400],
              ),
            ),
            Tab(
              icon: Icon(
                Icons.star,
                color: Colors.pinkAccent[400],
              ),
            ),
          ],
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton.extended(
                backgroundColor: Colors.pinkAccent[400],
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text('NEW CATEGORY'),
                onPressed: () {},
              )
            : FloatingActionButton(
                backgroundColor: Colors.pinkAccent[400],
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
