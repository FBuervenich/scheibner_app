import 'package:flutter/material.dart';
import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/commonWidgets/menuButton.dart';

class SimulationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          ScheibnerLocalizations.of(context).getValue("simulationTitle"),
        ),
        leading: new MenuButton(),
        actions: <Widget>[
        
        ],
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: new Text("Change data for simulation here"),
          ),
          new RaisedButton(
            child: new Text("Simulate values"),
            onPressed: () {
              Navigator.pushNamed(context, '/results');
            },
          ),
        ],
      ),
    );
  }
}
