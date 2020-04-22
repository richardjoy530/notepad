import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notepad/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String noteTable = 'note_table';
  String colId = 'id';
  String colStarred = 'starred';
  String colTitle = 'title';
  String colText = 'text';
  String colCategory = 'category';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colStarred INTEGER, $colCategory TEXT , $colTitle TEXT, $colText TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    print(['In insert function : Id = ', note.id]);
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> deleteAllNote() async {
    var db = await this.database;
    return await db.rawDelete('DELETE FROM $noteTable');
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      Note temp = Note('', '', Category('Not Specified'));
      temp.id = noteMapList[i]['id'];
      temp.starred = noteMapList[i]['starred'];
      temp.title = noteMapList[i]['title'];
      temp.text = noteMapList[i]['text'];
      temp.category.name = noteMapList[i]['category'];
      temp.category.color = getCategoryColor(temp.category.name, prefs);
      noteList.add(temp);
    }

    return noteList;
  }

  Color getCategoryColor(String name, SharedPreferences prefs) {
    var colorName;
    colorName = (prefs.getString(name) ?? 'blue');
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
}
