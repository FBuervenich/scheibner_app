import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preferences/preference_service.dart';

import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/helpers/measurementService.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scheibner_app/helpers/scheibnerException.dart';

class DataInputPage extends StatefulWidget {
  @override
  _DataInputState createState() => new _DataInputState();
}

class _DataInputState extends State<DataInputPage> {
  String barcode = "";
  Data measurementData;
  ApiService apiService = new ApiService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          AppTranslations.of(context).text("dataInputTitle"),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/preferences');
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
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
                      builder: (context, child, model) => new ListView.builder(
                            itemCount: model.getMeasurementData() != null
                                ? Data.showable.length
                                : 1,
                            itemBuilder: (context, position) =>
                                _createMeasValueList(context, model, position),
                          ),
                    ),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: () async {
                        try {
                          Data measurementData =
                              await apiService.getMeasurementFromId(
                                  0); // TODO use id from textfield
                          processMeasurement(measurementData);
                        } on ScheibnerException catch (e) {
                          this._showToast(context,
                              AppTranslations.of(context).text(e.toString()));
                        }
                      },
                      child: new Text(
                        AppTranslations.of(context).text("loadFromServer"),
                      ),
                    ),
                    new RaisedButton(
                      onPressed: () async {
                        try {
                          setState(() => this.barcode = "");
                          await scan(context);

                          if (this.barcode != "") {
                            measurementData =
                                apiService.getMeasurementFromJson(barcode);
                            processMeasurement(measurementData);
                          }
                        } on ScheibnerException catch (e) {
                          this._showToast(context,
                              AppTranslations.of(context).text(e.toString()));
                        }
                      },
                      child: Text(
                        AppTranslations.of(context).text("loadFromQRCode"),
                      ),
                    ),
                  ],
                ),
                new ScopedModelDescendant<AppModel>(
                  builder: (context, child, model) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new RaisedButton(
                            onPressed: model.getMeasurementData() != null
                                ? () {
                                    Navigator.pushNamed(context, '/simulation');
                                  }
                                : null,
                            child: new Text("Edit for Simulation"),
                          ),
                          new RaisedButton(
                            onPressed: null,
                            child: Text("Load last simulation"),
                          ),
                        ],
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _createMeasValueList(
      BuildContext context, AppModel model, int position) {
    if (model.getMeasurementData() == null) {
      return new Center(
        child: new Text("No data loaded"),
      );
    }

    String name = Data.showable[position];
    double measValue = model.getMeasValue(name);

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
            new Text(
              measValue != null
                  ? measValue.toStringAsFixed(1)
                  : "Value could not be calculated",
              style: defaultTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  void processMeasurement(Data measurementData) {
    ScopedModel.of<AppModel>(context).setMeasurementData(measurementData);
    ScopedModel.of<AppModel>(context)
        .setSimulationData(Data.clone(measurementData));
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
