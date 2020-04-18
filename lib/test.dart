//// with builder
//Future<void> showCategories() async {
//  switch (await showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return SimpleDialog(
//          shape:
//              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//          title: Text(
//            'Select a Category',
//            style: TextStyle(color: Colors.redAccent),
//          ),
//          children: <Widget>[
//            ListView.builder(itemBuilder: (context, categoryListIndex) {
//              return SimpleDialogOption(
//                child: ListTile(
//                  leading: Icon(Icons.bookmark),
//                  title: Text(category[categoryListIndex]),
//                ),
//                onPressed: () {
//                  Navigator.pop(context, category[categoryListIndex]);
//                },
//              );
//            }),
//          ],
//        );
//      })) {
//    case 'Not Specified':
//      print('Option 1');
//      break;
//    case 'Sooper Sanams':
//      print('Option 2');
//      break;
//  }
//}
//
////no builder
//Future<void> showCategories() async {
//  switch (await showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return SimpleDialog(
//          backgroundColor: Colors.grey[900],
//          shape:
//              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//          title: Text(
//            'Select a Category',
//            style:
//                TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
//          ),
//          children: <Widget>[
//            SimpleDialogOption(
//              child: ListTile(
//                leading: Icon(
//                  Icons.bookmark,
//                  color: Colors.greenAccent,
//                ),
//                title: Text(category[0], style: TextStyle(color: titleColor)),
//              ),
//              onPressed: () {
//                Navigator.pop(context, category[0]);
//              },
//            ),
//            SimpleDialogOption(
//              child: ListTile(
//                leading: Icon(Icons.bookmark, color: Colors.blueAccent),
//                title: Text(category[1], style: TextStyle(color: titleColor)),
//              ),
//              onPressed: () {
//                Navigator.pop(context, category[1]);
//              },
//            )
//          ],
//        );
//      })) {
//    case 'Not Specified':
//      print('Option 1');
//      break;
//    case 'Sooper Sanams':
//      print('Option 2');
//      break;
//  }
//}
