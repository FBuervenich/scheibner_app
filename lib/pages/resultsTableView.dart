import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/helpers/helperfunctions.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';

class TableView extends StatelessWidget {
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
              physics: BouncingScrollPhysics(),
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
    String unit = Data.units[position];
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
              AppTranslations.of(context).text(name) + " [$unit]",
              style: defaultTextStyle,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(
                  Helper.valToString(measValue),
                  style: defaultTextStyle,
                ),
                new Text(
                  Helper.valToString(simValue),
                  style: defaultTextStyle,
                ),
                new Text(
                  Helper.createDifferenceText(simValue, measValue),
                  style: defaultTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
