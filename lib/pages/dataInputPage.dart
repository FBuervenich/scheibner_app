import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/helpers/measurementService.dart';

class DataInputScreen extends StatefulWidget {
  @override
  DataInputPage createState() => new DataInputPage();
}

class DataInputPage extends State<DataInputScreen> {
  String barcode = "";
  Data measurementData;
  ApiService apiService = new ApiService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: new InputDecoration(
                      labelText: ScheibnerLocalizations.of(context)
                          .getValue("measurementID")),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: RaisedButton(
                  onPressed: () async {
                    measurementData = await apiService.getMeasurementFromId(0);
                    processMeasurement();
                  },
                  child: Text(ScheibnerLocalizations.of(context)
                      .getValue("loadFromServer")),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        RaisedButton(
          onPressed: () async {
            barcode = "";
            await scan();
            measurementData = apiService.getMeasurementFromJson(barcode);
          },
          child: Text(
              ScheibnerLocalizations.of(context).getValue("loadFromQRCode")),
        ),
      ])),
    );
  }

  void processMeasurement() {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(barcode),
    ));
  }

  String loadDataFromServer() {}

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
