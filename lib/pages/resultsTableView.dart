import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ScheibnerSim/data/appmodel.dart';
import 'package:ScheibnerSim/data/data.dart';
import 'package:ScheibnerSim/helpers/helperfunctions.dart';
import 'package:ScheibnerSim/localization/app_translations.dart';
import 'package:ScheibnerSim/styles.dart';
import 'package:scoped_model/scoped_model.dart';

class TableView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(0),
      child: new ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => _createListView(context, model),
      ),
    );
  }

  ListView _createListView(BuildContext context, AppModel model) {
    List<Widget> list = <Widget>[];
    if (model.getSimulationData() != null) {
      list = List.generate(Data.showable.length,
          (int i) => _createSimValueList(context, model, i));
      // add containers as dividers to group values
      list.insert(5, new Container(height: 30));
      list.insert(11, new Container(height: 30));
    }
    return new ListView(
      children: list,
      physics: BouncingScrollPhysics(),
    );
  }

  Widget _createSimValueList(
      BuildContext context, AppModel model, int position) {
    if (model.getSimulationData() == null) {
      return null;
    }

    ValueInfo valInfo = Data.showable[position];
    String name = valInfo.name;
    String unit = valInfo.unit;
    double measValue = model.getMeasValue(name);
    double simValue = model.getSimValue(name);

    return new Card(
      color: cardBackgroundColor,
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
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
                Helper.createDifferenceText(simValue, measValue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
