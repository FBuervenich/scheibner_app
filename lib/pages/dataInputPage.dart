import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/algorithm/simulation.dart';
import 'package:scheibner_app/commonWidgets/menuButton.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/helpers/measurementService.dart';
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
            ScheibnerLocalizations.of(context).getValue("dataInputTitle")),
        leading: new MenuButton(),
      ),
      body: Builder(
        // Create an inner BuildContext so that the onPressed methods
        // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Padding(
                padding: EdgeInsets.all(20.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
                          labelText: ScheibnerLocalizations.of(context)
                              .getValue("measurementID"),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        onPressed: () async {
                          try {
                            Data measurementData; // =
                            // await apiService.getMeasurementFromId(0);
                            processMeasurement(measurementData);
                          } on ScheibnerException catch (e) {
                            this._showToast(context, ScheibnerLocalizations.of(context)
                              .getValue(e.toString()));
                          }
                        },
                        child: new Text(ScheibnerLocalizations.of(context)
                            .getValue("loadFromServer")),
                      ),
                    ),
                  ],
                ),
              ),
              new Divider(),
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
                    this._showToast(context, ScheibnerLocalizations.of(context)
                              .getValue(e.toString()));
                  }
                },
                child: Text(ScheibnerLocalizations.of(context)
                    .getValue("loadFromQRCode")),
              ),
            ],
          );
        },
      ),
    );
  }

  void processMeasurement(Data measurementData) {
    // Scaffold.of(context).showSnackBar(new SnackBar(
    //   content: new Text(barcode),
    // ));
    measurementData = new Data(); // TODO for debugging
    new ScheibnerSimulation().calcAdditionalData(measurementData);
    ScopedModel.of<AppModel>(context).setMeasurementData(measurementData);
    Navigator.pushNamed(context, '/simulation');
  }

  Future scan(BuildContext context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        this._showToast(context,
            ScheibnerLocalizations.of(context).getValue("cameraPermissions"));
      } else {
        this._showToast(
            context,
            ScheibnerLocalizations.of(context).getValue("unknownError") +
                e.toString());
      }
    } on FormatException {
      //do nothing, user pressed back button
    } catch (e) {
      this._showToast(
          context,
          ScheibnerLocalizations.of(context).getValue("unknownError") +
              e.toString());
    }
  }

  void _showToast(BuildContext context, String str) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(str),
        action: SnackBarAction(
            label: ScheibnerLocalizations.of(context).getValue("close"), onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
