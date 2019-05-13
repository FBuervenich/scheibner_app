import 'package:flutter/material.dart';
import 'package:scheibner_app/helpers/appmodel.dart';
import 'package:scoped_model/scoped_model.dart';

class ergebnissePage extends StatelessWidget {
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
