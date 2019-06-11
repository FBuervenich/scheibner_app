import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/helpers/database_helpers.dart';
import 'package:scheibner_app/helpers/helperfunctions.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scheibner_app/helpers/helperfunctions.dart' as hf;

class SimulationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SimulationState();
}

class _SimulationState extends State<SimulationPage> {
  final Map<String, TextEditingController> _controllers = Map.fromIterable(
    Data.modifiable,
    key: (v) => v.name,
    value: (v) => new TextEditingController(),
  );
  final Map<String, double> _sliderValues = Map.fromIterable(
    Data.modifiable,
    key: (v) => v.name,
    value: (v) => null,
  );

  @override
  Widget build(BuildContext context) {
    String mode = PrefService.getString("input_mode");
    var inputListBuilder;
    if (mode == AppTranslations.of(context).text("inputModeTextFields")) {
      inputListBuilder = _createTextBoxList;
    } else {
      inputListBuilder = _createSliderList;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            "${AppTranslations.of(context).text("simulationTitle")} [${hf.Helper.getCurrentProfileName(context)}]"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/preferences');
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new ScopedModelDescendant<AppModel>(
              builder: (context, child, model) => new ListView(
                    children: inputListBuilder(context, model),
                    physics: BouncingScrollPhysics(),
                  ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(10),
            child: new RaisedButton.icon(
              label: new Text(AppTranslations.of(context).text("simulate")),
              icon: Icon(Icons.equalizer),
              onPressed: () {
                AppModel model = ScopedModel.of<AppModel>(context);
                model.simulate();
                DatabaseHelper.instance.changeSimData(
                    model.getProfile().id, model.getSimulationData());
                Navigator.pushNamed(context, '/results');
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createSliderList(BuildContext context, AppModel model) {
    if (model.getMeasurementData() == null) {
      return [
        new Center(
          child: new Text("No data loaded"),
        ),
      ];
    }
    return Data.modifiable.map(
      (ValueInfo valInfo) {
        String name = valInfo.name;
        String unit = valInfo.unit;
        double measValue = model.getMeasValue(name);
        double simValue;
        if (_sliderValues[name] == null) {
          simValue = model.getSimValue(name);
          _sliderValues[name] = simValue;
        } else {
          simValue = _sliderValues[name];
        }

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      measValue.toStringAsFixed(1),
                      style: defaultTextStyle,
                    ),
                    new Text(
                      simValue.toStringAsFixed(1),
                      style: defaultTextStyle,
                    ),
                    new Align(
                      alignment: Alignment.centerRight,
                      child: Helper.createDifferenceText(simValue, measValue),
                    ),
                  ],
                ),
                new Slider(
                  value: simValue,
                  min: valInfo.lowerBound,
                  max: valInfo.upperBound,
                  onChanged: (double value) {
                    setState(() {
                      _sliderValues[name] = value;
                    });
                  },
                  onChangeEnd: (double value) {
                    model.setSimValue(name, value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  List<Widget> _createTextBoxList(BuildContext context, AppModel model) {
    if (model.getMeasurementData() == null) {
      return [
        new Center(
          child: new Text("No data loaded"),
        ),
      ];
    }

    return Data.modifiable.map(
      (ValueInfo valInfo) {
        String name = valInfo.name;
        String unit = valInfo.unit;
        double measValue = model.getMeasValue(name);
        double simValue = model.getSimValue(name);
        TextEditingController controller = _controllers[name];
        controller.text = simValue.toStringAsFixed(1);

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
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        measValue.toStringAsFixed(1),
                        style: defaultTextStyle,
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        width: 100,
                        height: 40,
                        child: new TextField(
                          keyboardType:
                              TextInputType.numberWithOptions(signed: false),
                          controller: controller,
                          onSubmitted: (String text) {
                            double val =
                                double.tryParse(_controllers[name].text);
                            if (val != null) {
                              model.setSimValue(name, val);
                              // necessary to update slider value
                              _sliderValues[name] = null;
                            }
                          },
                          style: defaultTextStyle,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Align(
                        alignment: Alignment.centerRight,
                        child: Helper.createDifferenceText(simValue, measValue),
                      ),
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

  @override
  void dispose() {
    _controllers.forEach((name, o) => o.dispose());
    super.dispose();
  }
}
