import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/commonWidgets/menuButton.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/helpers/measurementService.dart';
import 'package:scoped_model/scoped_model.dart';

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
      body: new Column(
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
                      Data measurementData;// =
                          // await apiService.getMeasurementFromId(0);
                      processMeasurement(measurementData);
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
              barcode = "";
              await scan();
              measurementData = apiService.getMeasurementFromJson(barcode);
              processMeasurement(measurementData);
            },
            child: Text(
                ScheibnerLocalizations.of(context).getValue("loadFromQRCode")),
          ),
        ],
      ),
    );
  }

  void processMeasurement(Data measurementData) {
    // Scaffold.of(context).showSnackBar(new SnackBar(
    //   content: new Text(barcode),
    // ));
    ScopedModel.of<AppModel>(context).setMeasurementData(measurementData);
    Navigator.pushNamed(context, '/simulation');
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
