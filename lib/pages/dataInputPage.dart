import 'package:flutter/material.dart';
import 'package:scheibner_app/Localizations.dart';

class DataInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  //TODO implement
                },
                child: Text("Load from server"),),
              RaisedButton(
                onPressed: () {
                  //TODO implement
                },
                child: Text("Load from QR-code"),),
            ]
          )
      ),
    );
  }
}