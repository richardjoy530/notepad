import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color titleColor = Colors.white;
Color textColor = Colors.grey[700];

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool pinEnable;
  String pin;

  @override
  void initState() {
    super.initState();
    loadPinData();
  }

  void setPinData(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('pinEnable', value);
  }

  void loadPinData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      pinEnable = (prefs.getBool('pinEnable') ?? false);
      if (pinEnable == true) {
        pin = (prefs.getInt('pin') ?? '000');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Divider(
              thickness: 1,
              color: Colors.grey[700],
            ),
          ),
          ListTile(
            title: Text(
              'Google Drive Backup',
              style: TextStyle(color: titleColor),
            ),
            subtitle: Text(
                'Backup all your notes to your Google Drives\'s Storage space',
                style: TextStyle(color: textColor)),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Divider(
              thickness: 1,
              color: Colors.grey[700],
            ),
          ),
          ListTile(
            title: Text('PIN-Code', style: TextStyle(color: titleColor)),
            subtitle: Text(
                'Request a Pin Code while opening the app. Enable/ Disable the checkbox on right.\nOnce PIN is setup, fingerprint protection option will be made available in the settings.',
                style: TextStyle(color: textColor)),
            trailing: Checkbox(
              value: pinEnable,
              onChanged: (value) {
                setState(() {
                  pinEnable = !pinEnable;
                });
              },
              checkColor: textColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Divider(
              thickness: 1,
              color: Colors.grey[700],
            ),
          ),
          ListTile(
            title: Text('Fingerprint Authentication',
                style: TextStyle(color: titleColor)),
            subtitle: Text(
                'Use finger print authentication aling with PIN-Code protection',
                style: TextStyle(color: textColor)),
            trailing: Checkbox(
              value: false,
              onChanged: null,
              checkColor: textColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Divider(
              thickness: 1,
              color: Colors.grey[700],
            ),
          ),
          ListTile(
            title: Text('Text Limiter', style: TextStyle(color: titleColor)),
            subtitle: Text(
                'Manage the amount of text lines to be displayed on home screen (excluding the title).',
                style: TextStyle(color: textColor)),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Divider(
              thickness: 1,
              color: Colors.grey[700],
            ),
          ),
          ListTile(
            title: Text('Export notes', style: TextStyle(color: titleColor)),
            subtitle: Text('Export notes to device storage',
                style: TextStyle(color: textColor)),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Divider(
              thickness: 1,
              color: Colors.grey[700],
            ),
          ),
          ListTile(
            title: Text('Import notes', style: TextStyle(color: titleColor)),
            subtitle: Text(
                'In order to import from different device, copy folder',
                style: TextStyle(color: textColor)),
          )
        ],
      ),
    );
  }
}
