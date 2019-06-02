import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/framedButton.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scheibner_app/styles.dart';

class SaveView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(15),
            child: new TextField(
              onSubmitted: null,
              maxLines: null,
              decoration: new InputDecoration(
                labelText: "Add a description",
                filled: true,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              keyboardType: TextInputType.multiline,
              style: defaultTextStyle,
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(15),
            child: new RaisedButton.icon(
              label: new Text(AppTranslations.of(context).text("saveSimulation")),
              icon: Icon(Icons.save),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
