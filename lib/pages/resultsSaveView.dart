import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/helpers/database_helpers.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';

class SaveView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SaveViewState();
}

class _SaveViewState extends State<SaveView> {
  TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: cardBackgroundColor,
      child: new Container(
        padding: EdgeInsets.all(15),
        child: new ScopedModelDescendant<AppModel>(
          builder: (context, child, model) {
            _textEditingController.text = model.getProfile().comment ?? "";
            return new TextField(
                onChanged: (String text) {
                  model.setComment(text);
                  DatabaseHelper.instance.saveProfile(model.getProfile());
                },
                maxLines: null,
                decoration: new InputDecoration(
                  labelText: AppTranslations.of(context).text("addDescription"),
                  filled: true,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                style: defaultTextStyle,
                controller: _textEditingController,
              );
          }
        ),
      ),
    );
  }
}
