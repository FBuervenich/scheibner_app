import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/profile.dart';
import 'package:scheibner_app/helpers/database_helpers.dart';
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

  ReducedProfile.fromMap(Map<String, dynamic> map) {
    this.profileID = map[colProfileId];
    this.name = map[colProfileName];
    this.lastChanged = DateTime.tryParse(map[colLastChanged]);
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfiletState createState() => new _ProfiletState();
}

class _ProfiletState extends State<ProfilePage> {
  List<ReducedProfile> _profiles;
  final dbHelper = DatabaseHelper.instance;

  @override
  initState() {
    _profiles = new List<ReducedProfile>();
    _reloadProfiles();
    super.initState();
  }

  void _reloadProfiles() async {
    var tempProjects = await dbHelper.getRedProfileList();
    setState(() {
      _profiles = tempProjects;
    });
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
      // backgroundColor: Colors.black,
      body: Builder(builder: _makeContent),
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

  Widget _makeContent(BuildContext context) {
    if (_profiles.length > 0) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _profiles.length,
        itemBuilder: _makeCard,
      );
    } else {
      return Container(
        child: _makeNoProfilesWidget(context),
      );
    }
  }

  Widget _makeNoProfilesWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.insert_drive_file,
              size: 50,
            ),
            Container(height: 20),
            Text(AppTranslations.of(context).text("noExistingProfiles"),
                style: Theme.of(context).textTheme.display4),
            Container(height: 00)
          ],
        ),
      ],
    );
  }

  Widget _makeCard(BuildContext context, int index) {
    final item = _profiles[index];
    return Dismissible(
      direction: DismissDirection.endToStart,
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify Widgets.
      key: Key(item.profileID.toString()),
      // We also need to provide a function that will tell our app
      // what to do after an item has been swiped away.
      onDismissed: (direction) async {
        Profile fullProfile = await dbHelper.loadProfile(item.profileID);
        // Remove the item from our data source.
        setState(() {
          _profiles.remove(item);
        });
        // DELETE FROM DB HERE
        dbHelper.deleteProfile(item.profileID);

        // Show a snackbar! Also let the user undo his deletion!
        Scaffold.of(context)
            .showSnackBar(new SnackBar(
              content: new Text(
                  "${AppTranslations.of(context).text("profile")} ${item.name} ${AppTranslations.of(context).text("deleted")}."),
              action: new SnackBarAction(
                  label: AppTranslations.of(context).text("undo"),
                  onPressed: () {
                    _profiles.add(item);
                    // save the project back to db and reload everything
                    dbHelper.insertProfile(fullProfile);
                    _reloadProfiles();
                  }),
            ))
            // wait for the SnackBar to close
            .closed
            .then((SnackBarClosedReason reason) {
          if (reason != SnackBarClosedReason.action) {
            // (SnackBar has closed, now the deletion can NOT be undone!!)
          }
        });
      },
      background: Container(
        margin: new EdgeInsets.symmetric(horizontal: 0, vertical: 6.0),
        color: highlightColor,
        child: Container(
          margin: new EdgeInsets.symmetric(horizontal: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(),
            _getDeleteIconColumn(),
          ]),
        ),
      ),
      child: new GestureDetector(
        // stack to put an inkwell above
        child: new Stack(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 0, vertical: 6.0),
              color: cardBackgroundColor,
              child: ListTile(
                leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.white24)),
                        ),
                        child: Icon(Icons.directions_bike, color: Colors.white),
                      )
                    ]),
                title: Text(
                  item.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: highlightColor,
                      size: 15,
                    ),
                    Text(" " + _dateToString(item.lastChanged),
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
                    // load data and switch to input data page
                    _openProfile(item.profileID);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateToString(DateTime date) {
    var formatter =
        new DateFormat(AppTranslations.of(context).text("dateFormat"));
    String formatted = formatter.format(date);
    return formatted; // something like 2013-04-20
  }

  _openProfile(int id) async {
    Profile p = await dbHelper.loadProfile(id);
    ScopedModel.of<AppModel>(context).setProfile(p);
    Navigator.pushNamed(context, '/inputdata');
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
                  var projectName = _textFieldController.text;

                  if (projectName.length > 0) {
                    // return "createProfile" so it can be determined what has been clicked from outside
                    Navigator.of(context).pop("success");
                  } else {
                    // no project name --> do nothing
                    return;
                  }
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

      // add the profile to the database
      dbHelper.createProfile(_textFieldController.text);
      // reload the profiles so the list is updated
      _reloadProfiles();

      // reset the profile name input
      _textFieldController.text = "";
    }
  }

  Widget _getDeleteIconColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 30,
        ),
        Text(
          AppTranslations.of(context).text("delete"),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
