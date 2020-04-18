import 'dart:async';
import 'package:notepad/note.dart';
import 'package:notepad/helper.dart';
import 'package:notepad/addnote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: ListView(
        children: <Widget>[ListTile()],
      ),
    );
  }
}
