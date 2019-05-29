import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scoped_model/scoped_model.dart';
import '../styles.dart';

class ReducedProfile {
  int profileID;
  String name;
  DateTime lastChanged;
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfiletState createState() => new _ProfiletState();
}

class _ProfiletState extends State<ProfilePage> {
  int _itemCounter = 0;
  HashMap<int, String> _profiles;

  @override
  initState() {
    _profiles = new HashMap<int, String>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          AppTranslations.of(context).text("profileTitle"),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/preferences');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (BuildContext context) => ListView.builder(
              itemCount: _profiles.length,
              itemBuilder: (context, index) {
                final item = _profiles[index];
                return Dismissible(
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify Widgets.
                  key: Key(item),
                  // We also need to provide a function that will tell our app
                  // what to do after an item has been swiped away.
                  onDismissed: (direction) {
                    // Remove the item from our data source.
                    setState(() {
                      _profiles.remove(index);
                    });

                    // Show a snackbar! This snackbar could also contain "Undo" actions.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("$item index $index dismissed")));
                  },
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/inputdata');
                    },
                    child: new Card(
                      child: new Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("$item", style: TextStyle(fontSize: 22.0)),
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
              onPressed: () {
                _displayNewProfileNameDialog(context);
              },
              child: Icon(
                Icons.add,
              ),
            ),
      ),
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  _displayNewProfileNameDialog(BuildContext context) async {
    // save the return val to check if the dialog was dismissed or not
    String retVal = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppTranslations.of(context).text("newProfile")),
            content: TextField(
              controller: _textFieldController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText:
                      AppTranslations.of(context).text("enterProfileName"),
                  hintText: AppTranslations.of(context).text("profileName")),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(AppTranslations.of(context).text("cancel")),
                onPressed: () {
                  _textFieldController.text = "";
                  // return "cancel" so it can be determined what has been clicked from outside
                  Navigator.of(context).pop("cancel");
                },
              ),
              new RaisedButton(
                child:
                    new Text(AppTranslations.of(context).text("createProfile")),
                onPressed: () {
                  // return "createProfile" so it can be determined what has been clicked from outside
                  Navigator.of(context).pop("success");
                },
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
              )
            ],
          );
        });

    // dialog has been dismissed -> clear text field
    if (retVal == null) {
      _textFieldController.text = "";
    } else if (retVal == "success") {
      // user clicked the "success" button

      // add the profile
      for (int i = 0; i < 10; i++) {
        _profiles[_itemCounter] = _textFieldController.text;
        _itemCounter++;
      }
      _textFieldController.text = "";
    }
  }
}
