import 'package:flutter/material.dart';
import 'package:notepad/note.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  Category newCategory = Category('');
  Color dividerColor = Colors.cyanAccent;
  TextEditingController categoryTextController;

  @override
  void initState() {
    categoryTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    categoryTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ListTile(
                leading: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Text(
                  'Add Category',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (categoryTextController.text != '') {
                        newCategory.name = categoryTextController.text;
                        newCategory.color = dividerColor;
                        Navigator.pop(context, newCategory);
                      }
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Divider(thickness: 2, color: dividerColor),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                controller: categoryTextController,
                maxLength: 25,
                decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Category Title',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20,
              width: double.infinity,
            ),
            Text('You can add a color here',
                style: TextStyle(color: Colors.grey[400])),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        dividerColor = Colors.redAccent;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        dividerColor = Colors.blueAccent;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Colors.yellowAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        dividerColor = Colors.yellowAccent;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Colors.lightGreenAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        dividerColor = Colors.lightGreenAccent;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Colors.purpleAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        dividerColor = Colors.purpleAccent;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        dividerColor = Colors.pinkAccent;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Colors.cyanAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        dividerColor = Colors.cyanAccent;
                      });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
