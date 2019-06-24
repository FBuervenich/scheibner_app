import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/threePointMenu.dart';
import 'package:unicorndial/unicorndial.dart';

import 'package:ScheibnerSim/data/appmodel.dart';
import 'package:ScheibnerSim/data/data.dart';
import 'package:ScheibnerSim/helpers/database_helpers.dart';
import 'package:ScheibnerSim/helpers/measurementService.dart';
import 'package:ScheibnerSim/styles.dart';
import 'package:ScheibnerSim/localization/app_translations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ScheibnerSim/helpers/scheibnerException.dart';
import 'package:ScheibnerSim/helpers/helperfunctions.dart' as hf;
import 'package:flutter_spinkit/flutter_spinkit.dart';

///class DataInputPage
class DataInputPage extends StatefulWidget {
  @override
  ///create state for DataInputPage
  _DataInputState createState() => new _DataInputState();
}

///state for DataInputPage
class _DataInputState extends State<DataInputPage> {
  String barcode = "";
  Data measurementData;
  ApiService apiService = new ApiService();
  TextEditingController _textFieldController = TextEditingController();
  bool isLoading = false;
  var loadingSubScription;

  @override
  ///init state for DataInputState
  initState() {
    super.initState();
  }

  ///build for DataInputState
  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: AppTranslations.of(context).text("loadFromServer"),
      currentButton: FloatingActionButton(
        heroTag: "cloud",
        backgroundColor: highlightColor,
        mini: true,
        child: Icon(Icons.cloud),
        onPressed: () {
          var model = ScopedModel.of<AppModel>(context);
          _displayMeasIdDialog(context, model);
        },
      ),
    ));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: AppTranslations.of(context).text("loadFromQRCode"),
        currentButton: FloatingActionButton(
          heroTag: "select_all",
          backgroundColor: highlightColor,
          mini: true,
          child: Icon(Icons.select_all),
          onPressed: () async {
            try {
              setState(() => this.barcode = "");
              await scan(context);

              if (this.barcode != "") {
                measurementData = apiService.getMeasurementFromJson(barcode);
                processMeasurement(measurementData);
              }
            } on ScheibnerException catch (e) {
              this._showToast(
                  context, AppTranslations.of(context).text(e.toString()));
            }
          },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: AppTranslations.of(context).text("editForSimulation"),
        currentButton: FloatingActionButton(
          heroTag: "edit",
          backgroundColor: highlightColor,
          mini: true,
          child: Icon(Icons.edit),
          onPressed: () {
            var model = ScopedModel.of<AppModel>(context);
            if (model.getMeasurementData() != null) {
              if (model.getSimulationData() == null) {
                model.setSimulationData(Data.clone(model.getMeasurementData()));
              }
              Navigator.pushNamed(context, '/simulation');
            }
          },
        )));

    return new Scaffold(
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
          parentButtonBackground: highlightColor,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.menu),
          childButtons: childButtons),
      appBar: new AppBar(
        title: new Text(
          "${AppTranslations.of(context).text("dataInputTitle")} [${hf.Helper.getCurrentProfileName(context)}]",
        ),
        actions: <Widget>[
          new ThreePointWidget(),
        ],
      ),
      body: Builder(
        // Create an inner BuildContext so that the onPressed methods
        // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return new Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Expanded(
                  child: new Padding(
                    padding: EdgeInsets.all(0),
                    child: new ScopedModelDescendant<AppModel>(
                      builder: (context, child, model) =>
                          _createListView(context, model),
                    ),
                  ),
                ),
                // new Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: <Widget>[
                //     new ScopedModelDescendant<AppModel>(
                //       builder: (context, child, model) => new RaisedButton.icon(
                //             onPressed: () =>
                //                 _displayMeasIdDialog(context, model),
                //             label: Text(
                //               AppTranslations.of(context)
                //                   .text("loadFromServer"),
                //             ),
                //             icon: Icon(Icons.cloud),
                //           ),
                //     ),
                //     new RaisedButton.icon(
                //         onPressed: () async {
                //           try {
                //             setState(() => this.barcode = "");
                //             await scan(context);

                //             if (this.barcode != "") {
                //               measurementData =
                //                   apiService.getMeasurementFromJson(barcode);
                //               processMeasurement(measurementData);
                //             }
                //           } on ScheibnerException catch (e) {
                //             this._showToast(context,
                //                 AppTranslations.of(context).text(e.toString()));
                //           }
                //         },
                //         label: Text(
                //           AppTranslations.of(context).text("loadFromQRCode"),
                //         ),
                //         icon: Icon(Icons.select_all)),
                //   ],
                // ),
                // new ScopedModelDescendant<AppModel>(
                //   builder: (context, child, model) => Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: <Widget>[
                //           new RaisedButton.icon(
                //             onPressed: model.getMeasurementData() != null
                //                 ? () {
                //                     if (model.getSimulationData() == null) {
                //                       model.setSimulationData(Data.clone(
                //                           model.getMeasurementData()));
                //                     }
                //                     Navigator.pushNamed(context, '/simulation');
                //                   }
                //                 : null,
                //             label: new Text(AppTranslations.of(context)
                //                 .text("editForSimulation")),
                //             icon: Icon(Icons.edit),
                //           ),
                //         ],
                //       ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  ///creates a list view with all data
  Widget _createListView(BuildContext context, AppModel model) {
    if (isLoading) {
      return new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new SpinKitRing(
              color: highlightColor,
            ),
            Container(height: 20),
            new FlatButton(
              child: new Text(
                AppTranslations.of(context).text("cancelServerRequest"),
                style: TextStyle(color: highlightColor),
              ),
              onPressed: () {
                if (loadingSubScription != null) {
                  loadingSubScription.cancel();
                }
                setState(() {
                  isLoading = false;
                  loadingSubScription = null;
                });
              },
            ),
          ],
        ),
      );
    }

    if (model.getMeasurementData() == null) {
      return _makeNoProfilesWidget(context);
    }
    List<Widget> list = <Widget>[];
    if (model.getMeasurementData() != null) {
      list = List.generate(Data.showable.length,
          (int i) => _createMeasValueList(context, model, i));
      // add containers as dividers to group values
      list.insert(5, new Container(height: 30));
      list.insert(11, new Container(height: 30));
    }
    return new ListView(
      children: list,
      physics: BouncingScrollPhysics(),
    );
  }

  ///creates a widget that indicates that there are no profiles
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
            Text(AppTranslations.of(context).text("noDataLoaded"),
                style: Theme.of(context).textTheme.display4),
            Container(height: 00)
          ],
        ),
      ],
    );
  }

  ///creates a list with all values for the measurement
  Widget _createMeasValueList(
      BuildContext context, AppModel model, int position) {
    ValueInfo valInfo = Data.showable[position];
    String name = valInfo.name;
    double measValue = model.getMeasValue(name);

    return new Card(
      color: cardBackgroundColor,
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 100,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text(
              AppTranslations.of(context).text(name),
              style: defaultTextStyle,
            ),
            new Text(
              (measValue?.toStringAsFixed(1) ?? "") + " " + valInfo.unit,
              style: defaultTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  ///creates a dialog in which a measurement id can be entered
  void _displayMeasIdDialog(BuildContext context, AppModel model) async {
    if (model.getProfile().serverId != null) {
      _textFieldController.text = model.getProfile().serverId.toString();
    }
    // save the return val to check if the dialog was dismissed or not
    String retVal = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppTranslations.of(context).text("loadFromServer")),
            content: TextField(
              controller: _textFieldController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: AppTranslations.of(context).text("enterMeasId"),
                  hintText: AppTranslations.of(context).text("measId")),
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
                child: new Text(AppTranslations.of(context).text("loadMeas")),
                onPressed: () {
                  Navigator.of(context).pop("success");
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
      setState(() {
        isLoading = true;
        loadingSubScription = null;
      });
      int measId = int.tryParse(_textFieldController.text);
      if (measId != null) {
        try {
          var sub = apiService
              .getMeasurementFromId(measId)
              .asStream()
              .listen((Data measurementData) {
            model.setMeasurementId(measId);
            DatabaseHelper.instance
                .changeServerId(model.getProfile().id, measId);
            processMeasurement(measurementData);
            setState(() {
              loadingSubScription = null;
              isLoading = false;
            });
          });

          setState(() {
            loadingSubScription = sub;
          });
        } on ScheibnerException catch (e) {
          this._showToast(
              context, AppTranslations.of(context).text(e.toString()));
        }
      } else {
        // no valid measurement ID
        this._showToast(
            context, AppTranslations.of(context).text("invalidMeasId"));
      }
    }
  }

  ///processes a measurement for a given Data [measurementData]
  void processMeasurement(Data measurementData) {
    AppModel model = ScopedModel.of<AppModel>(context);
    model.setMeasurementData(measurementData);
    model.setSimulationData(Data.clone(measurementData));
    DatabaseHelper.instance
        .changeMeasData(model.getProfile().id, measurementData);
    DatabaseHelper.instance
        .changeSimData(model.getProfile().id, measurementData);
  }

  Future scan(BuildContext context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        this._showToast(
            context, AppTranslations.of(context).text("cameraPermissions"));
      } else {
        this._showToast(context,
            AppTranslations.of(context).text("unknownError") + e.toString());
      }
    } on FormatException {
      //do nothing, user pressed back button
    } catch (e) {
      this._showToast(context,
          AppTranslations.of(context).text("unknownError") + e.toString());
    }
  }

  ///show toast message at the bottom that shows the message [str]
  void _showToast(BuildContext context, String str) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(str),
        action: SnackBarAction(
            label: AppTranslations.of(context).text("close"),
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
