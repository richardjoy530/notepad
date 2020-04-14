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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SpaceMono'),
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.pinkAccent[400],
            tabs: <Widget>[
              Tab(
                //text: 'Categories',
                icon: Icon(
                  Icons.category,
                  color: _tabController.index == 0
                      ? Colors.pinkAccent[400]
                      : Colors.grey[500],
                ),
              ),
              Tab(
                //text: 'Notes',
                icon: Icon(
                  Icons.note,
                  color: _tabController.index == 1
                      ? Colors.pinkAccent[400]
                      : Colors.grey[500],
                ),
              ),
              Tab(
                //text: 'Starred',
                icon: Icon(
                  Icons.star_half,
                  color: _tabController.index == 2
                      ? Colors.pinkAccent[400]
                      : Colors.grey[500],
                ),
              ),
            ],
          ),
          leading: Icon(
            Icons.menu,
            size: 30,
            color: Colors.grey[500],
          ),
          title: Text(
            'Categories',
            style: TextStyle(
              fontFamily: 'SpaceMono',
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 6,
            ),
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
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.pinkAccent[400],
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
