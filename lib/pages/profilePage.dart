import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import '../styles.dart';

class ReducedProfile {
  int profileID;
  String name;
  DateTime lastChanged;

  ReducedProfile(int profileID, String name, DateTime lastChanged) {
    this.profileID = profileID;
    this.name = name;
    this.lastChanged = lastChanged;
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfiletState createState() => new _ProfiletState();
}

class _ProfiletState extends State<ProfilePage> {
  int _itemCounter = 0;
  List<ReducedProfile> _profiles;

  @override
  initState() {
    _profiles = new List<ReducedProfile>();
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
              physics: BouncingScrollPhysics(),
              // shrinkWrap: true,
              itemCount: _profiles.length,
              itemBuilder: _makeCard,
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

  Widget _makeCard(BuildContext context, int index) {
    final item = _profiles[index];
    return Dismissible(
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify Widgets.
      key: Key(item.profileID.toString()),
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
        // stack to put an inkwell above
        child: new Stack(
          children: <Widget>[
            Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              color: cardBackgroundColor,
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24)),
                  ),
                  child: Icon(Icons.directions_bike, color: Colors.white),
                ),
                title: Text(
                  item.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Icon(Icons.linear_scale, color: highlightColor),
                    Text(" " + _getDateString(),
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0),
              ),
            ),
            // put filling InkWell on top of the card so the card can be "inked"
            new Positioned.fill(
              child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/inputdata');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateString() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd - hh:mm');
    String formatted = formatter.format(now);
    return formatted; // something like 2013-04-20
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
      for (int i = 0; i < 5; i++) {
        _profiles.add(new ReducedProfile(
            _itemCounter, _textFieldController.text, DateTime.now()));
        _itemCounter++;
      }
      _textFieldController.text = "";
    }
  }
}
