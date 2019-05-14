import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/data/data.dart';

class DataInputScreen extends StatefulWidget {
  @override
  DataInputPage createState() => new DataInputPage();
}

class DataInputPage extends State<DataInputScreen> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        RaisedButton(
          onPressed: () {
            //TODO implement
          },
          child: Text("Load from server"),
        ),
        RaisedButton(
          onPressed: () async {
            await scan();
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text(barcode),
            ));
          },
          child: Text("Load from QR-code"),
        ),
      ])),
    );
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
