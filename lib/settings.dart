import 'package:flutter/material.dart';
import 'package:notepad/note.dart';
import 'package:notepad/pincodeset.dart';

Color titleColor = Colors.white;
Color textColor = Colors.grey[700];

class Settings extends StatefulWidget {
  final int pinEnable;
  final int textLimiter;

  Settings(this.pinEnable, this.textLimiter);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int textLimiter;
  PinData pinData = PinData();
  static int pinEnable;

  @override
  void initState() {
    pinEnable = widget.pinEnable;
    super.initState();
  }

  Future<void> updatePinEnable() async {
    pinData.getPinEnable().then((onValue) {
      pinEnable = onValue;
    });
  }

  Future<void> showTextLimiter(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.grey[900],
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            'Text Limiter',
            style: TextStyle(color: Colors.redAccent),
          ),
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  subtitle: Text(
                    'Select the number of lines to be displayed for each note.',
                    style: TextStyle(color: textColor),
                  ),
                ),
                SimpleDialogOption(
                  child: ListTile(
                    title:
                    Text('- One Line', style: TextStyle(color: textColor)),
                  ),
                  onPressed: () {
                    this.textLimiter = 1;
                    Navigator.pop(context);
                  },
                ),
                SimpleDialogOption(
                  child: ListTile(
                    title:
                    Text('- Two Line', style: TextStyle(color: textColor)),
                  ),
                  onPressed: () {
                    this.textLimiter = 2;
                    Navigator.pop(context);
                  },
                ),
                SimpleDialogOption(
                  child: ListTile(
                    title: Text('- Three Line',
                        style: TextStyle(color: textColor)),
                  ),
                  onPressed: () {
                    this.textLimiter = 3;
                    Navigator.pop(context);
                  },
                ),
                SimpleDialogOption(
                  child: ListTile(
                    title:
                    Text('- Four Line', style: TextStyle(color: textColor)),
                  ),
                  onPressed: () {
                    this.textLimiter = 4;
                    Navigator.pop(context);
                  },
                ),
                SimpleDialogOption(
                  child: ListTile(
                    title:
                    Text('- Five Line', style: TextStyle(color: textColor)),
                  ),
                  onPressed: () {
                    this.textLimiter = 5;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void navigateToPinCodeSet(BuildContext context) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PinCodeSet();
        },
      ),
    );
    if (result) {
      updatePinEnable();
    }
    if (!result) {
      updatePinEnable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            textLimiter =
            textLimiter == null ? widget.textLimiter : textLimiter;
            Navigator.pop(context, textLimiter);
            Navigator.pop(context, textLimiter);
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
              value: pinEnable == 1 ? true : false,
              onChanged: (newValue) {
                setState(() {
                  if (newValue) {
                    navigateToPinCodeSet(context);
                  } else {
                    pinData.setPinEnable(0);
                  }
                  updatePinEnable();
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
              value: pinEnable == 2 ? true : false,
              onChanged: (newValue) {
                setState(() {
                  if (newValue) {
                    pinData.setPinEnable(2);
                  } else {
                    pinData.setPinEnable(0);
                  }
                  updatePinEnable();
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
            title: Text('Text Limiter', style: TextStyle(color: titleColor)),
            subtitle: Text(
                'Manage the amount of text lines to be displayed on home screen (excluding the title).',
                style: TextStyle(color: textColor)),
            onTap: () {
              showTextLimiter(context);
            },
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
