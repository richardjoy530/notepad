import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Note {
  int id;
  int starred;
  String title;
  String text;
  String category;
  Color categoryColor;

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

class Category {
  String name;
  Color color;

  Category(this.name, {this.color = Colors.blueAccent});
}
