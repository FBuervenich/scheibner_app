import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:flutter/widgets.dart';
import 'package:ScheibnerSim/components/threePointMenu.dart';
import 'package:ScheibnerSim/data/appmodel.dart';
import 'package:ScheibnerSim/data/data.dart';
import 'package:ScheibnerSim/helpers/database_helpers.dart';
import 'package:ScheibnerSim/helpers/helperfunctions.dart';
import 'package:ScheibnerSim/localization/app_translations.dart';
import 'package:ScheibnerSim/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ScheibnerSim/helpers/helperfunctions.dart' as hf;

///class SimulationPage
class SimulationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SimulationState();
}

///state for SimulationPage
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
  ///build for SimulationPage
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
          new ThreePointWidget(),
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
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
              onPressed: () {
                AppModel model = ScopedModel.of<AppModel>(context);
                model.simulate();
                DatabaseHelper.instance.changeSimData(
                    model.getProfile().id, model.getSimulationData());
                Navigator.pushNamed(context, '/results');
              },
              child: Icon(
                Icons.equalizer,
              ),
            ),
      ),
    );
  }

  ///creates a list of sliders for values that can be changed for simulation
  List<Widget> _createSliderList(BuildContext context, AppModel model) {
    if (model.getMeasurementData() == null) {
      return [
        new Center(
          child: new Text("No data loaded"),
        ),
      ];
    }
    List<Widget> ret = Data.modifiable.map(
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
        ) as Widget;
      },
    ).toList();

    // append an empty element so if the floating action button overlaps content, the user can scroll it
    ret.add(getContainerSpacer(35.0));

    return ret;
  }

  ///wrapper for addional space
  Container getContainerSpacer(double spacing) {
    return new Container(
      child: new Padding(
        padding: EdgeInsets.all(spacing),
      ),
    );
  }

  ///creates a list of textboxes for values that can be changed for simulation
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
  ///dispose for SimulationPage
  void dispose() {
    _controllers.forEach((name, o) => o.dispose());
    super.dispose();
  }
}
