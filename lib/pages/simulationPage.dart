import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';

class SimulationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SimulationState();
}

class _SimulationState extends State<SimulationPage> {
  final Map<String, TextEditingController> _controllers = Map.fromIterable(
      Data.names,
      key: (name) => name,
      value: (name) => new TextEditingController());

  @override
  Widget build(BuildContext context) {
    String mode = PrefService.getString("input_mode");
    //@DNeuroth: check mode and decide whether to show sliders or numer input boxes
    if (mode ==
        AppTranslations.of(context).text("inputModeTextFields")) {
      //show textfields
    } else if (mode ==
        AppTranslations.of(context).text("inputModeSliders")) {
      //show sliders
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          AppTranslations.of(context).text("simulationTitle"),
        ),
        actions: <Widget>[],
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
                    children: _createTextBoxList(context, model),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createSliderList(BuildContext context, AppModel model) {
    return null; //TODO
  }

  List<Widget> _createTextBoxList(BuildContext context, AppModel model) {
    return Data.modifiable.map(
      (String name) {
        double measValue = model.getMeasValue(name);
        double simValue = model.getSimValue(name);
        TextEditingController controller = _controllers[name];
        controller.text = simValue.toStringAsFixed(1);

        return new Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: new Container(
            color: Colors.white,
            height: 100, //TODO
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(
                  AppTranslations.of(context).text(name),
                  style: DEFAULT_TEXT_STYLE,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Text(
                      measValue.toStringAsFixed(1),
                      style: DEFAULT_TEXT_STYLE,
                    ),
                    new Container(
                      width: 100,
                      height: 40,
                      child: new TextField(
                        keyboardType:
                            TextInputType.numberWithOptions(signed: false),
                        controller: controller,
                        onSubmitted: (String text) {
                          double val = double.tryParse(_controllers[name].text);
                          if (val != null) {
                            model.setSimValue(name, val);
                          }
                        },
                        style: DEFAULT_TEXT_STYLE,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    _createDifferenceText(simValue, measValue),
                  ],
                ),
                //TODO slider
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  Text _createDifferenceText(double simValue, double measValue) {
    String plus = "";
    if (simValue > measValue) {
      plus += "+";
    }
    return new Text(
      plus + (simValue - measValue).toStringAsFixed(1),
      style: DEFAULT_TEXT_STYLE,
    );
  }

  @override
  void dispose() {
    _controllers.forEach((name, o) => o.dispose());
    super.dispose();
  }
}
