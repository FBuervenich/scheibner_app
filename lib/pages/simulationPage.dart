import 'package:flutter/material.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scoped_model/scoped_model.dart';

class SimulationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          //TODO add ergebnissePage
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScopedModelDescendant<AppModel>(
                builder: (context, child, data) =>
                  Text('Data: ${data.getFrontwheel()}')),
              RaisedButton(
                onPressed: () {
                  AppModel model = ScopedModel.of<AppModel>(context);
                  model.setFrontwheel(model.getFrontwheel() + 1);
                }
              )
            ]
          )
        ),
    );
  }
}
