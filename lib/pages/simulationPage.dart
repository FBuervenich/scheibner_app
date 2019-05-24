import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/commonWidgets/menuButton.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';

class SimulationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String mode = PrefService.getString("input_mode");
    //@DNeuroth: check mode and decide whether to show sliders or numer input boxes
    if(mode == ScheibnerLocalizations.of(context).getValue("inputModeTextFields")){
      //show textfields
    }
    else if (mode == ScheibnerLocalizations.of(context).getValue("inputModeSliders")){
      //show sliders
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          ScheibnerLocalizations.of(context).getValue("simulationTitle"),
        ),
        leading: new MenuButton(),
        actions: <Widget>[
        
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white,
              child: new Text(
                "Simulate values",
                style: new TextStyle(fontSize: 20, color: Colors.amber[600]),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  width: 1.5,
                  color: Colors.amber[600],
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/results');
              },
            ),
          ),
          new Expanded(
            child: new ScopedModelDescendant<AppModel>(
              builder: (context, child, model) => new ListView(
                    // physics: new NeverScrollableScrollPhysics(),
                    children: _createWidgetList(context, model),

                    // builder: (context, child, model) => new GridView.count(
                    //       crossAxisCount: 2,
                    //       childAspectRatio: 1.5,
                    //       children: _createWidgetList2(context, model),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getValueWidget(BuildContext context, AppModel model, int i) {
    NameValuePair p = model.getMeasurementData().getShowableValues()[i];
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text("Test_A " + i.toString()),
        new Text("Test_B " + i.toString())
      ],
    );
  }

  List<Widget> _createWidgetList2(BuildContext context, AppModel model) {
    return model.getMeasurementData().getModifiableValues().map(
      (NameValuePair p) {
        return new Padding(
          padding: EdgeInsets.all(10),
          child: new Container(
            color: Colors.white,
            height: 100,
            child: new Column(
              children: <Widget>[
                new Expanded(
                  child: new Center(
                    child: new Text(
                      ScheibnerLocalizations.of(context).getValue(p.name),
                      style: DEFAULT_TEXT_STYLE,
                    ),
                  ),
                ),
                new Expanded(
                  child: new Center(
                    child: new Text(
                      p.value.toStringAsFixed(1),
                      style: DEFAULT_TEXT_STYLE,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  List<Widget> _createWidgetList(BuildContext context, AppModel model) {
    List<NameValuePair> modMeas =
        model.getMeasurementData().getModifiableValues();
    List<NameValuePair> modSim =
        model.getSimulationData().getModifiableValues();
    return List.generate(
      modMeas.length,
      (int i) {
        NameValuePair meas = modMeas[i];
        NameValuePair sim = modSim[i];
        return new Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: new Container(
            color: Colors.white,
            height: 100, //TODO
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(
                  ScheibnerLocalizations.of(context).getValue(meas.name),
                  style: DEFAULT_TEXT_STYLE,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Text(
                      meas.value.toStringAsFixed(1),
                      style: DEFAULT_TEXT_STYLE,
                    ),
                    new Text(
                      sim.value.toStringAsFixed(1),
                      style: DEFAULT_TEXT_STYLE,
                    ),
                    new Text(
                      (meas.value - sim.value).toStringAsFixed(1),
                      style: DEFAULT_TEXT_STYLE,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  // List<Widget> _createWidgetList3(BuildContext context, AppModel model) {
  //   return model
  //       .getMeasurementData()
  //       .getShowableValues()
  //       .expand((NameValuePair p) {
  //     return [
  //       new Center(
  //         child: new Text(
  //           ScheibnerLocalizations.of(context).getValue(p.name),
  //           style: DEFAULT_TEXT_STYLE,
  //         ),
  //       ),
  //       new Center(
  //         child: new Text(
  //           p.value.toStringAsFixed(1),
  //           style: DEFAULT_TEXT_STYLE,
  //         ),
  //       ),
  //     ];
  //   }).toList();
  // }
}
