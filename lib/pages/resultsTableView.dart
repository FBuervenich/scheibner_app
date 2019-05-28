import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';

class TableView extends StatelessWidget {
  static const EPS = 5e-2;
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(0),
      child: new ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => new ListView.builder(
              itemCount:
                  model.getSimulationData() != null ? Data.showable.length : 1,
              itemBuilder: (context, position) =>
                  _createSimValueList(context, model, position),
            ),
      ),
    );
  }

  Widget _createSimValueList(
      BuildContext context, AppModel model, int position) {
    if (model.getSimulationData() == null) {
      return new Center(
        child: new Text("No simulation result available"),
      );
    }

    String name = Data.showable[position];
    double measValue = model.getMeasValue(name);
    double simValue = model.getSimValue(name);

    return new Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        height: 100,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text(
              AppTranslations.of(context).text(name),
              style: defaultTextStyle,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(
                  measValue.toStringAsFixed(1),
                  style: defaultTextStyle,
                ),
                new Text(
                  simValue.toStringAsFixed(1),
                  style: defaultTextStyle,
                ),
                new Text("asdf"),//_createDifferenceText(simValue, measValue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text _createDifferenceText(double simValue, double measValue) {
    String text = "";
    if ((simValue - measValue).abs() < EPS) {
      text = "0.0";
    } else {
      if (simValue > measValue) {
        text += "+";
      }
      text += (simValue - measValue).toStringAsFixed(1);
    }
    return new Text(
      text,
      style: defaultTextStyle,
    );
  }
}
