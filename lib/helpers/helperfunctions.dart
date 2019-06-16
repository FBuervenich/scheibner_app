import 'package:flutter/cupertino.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';

class Helper {
  static const EPS = 5e-2;

  static String valToString(double d) {
    if(d == null){
      return "Null";
    }
    if(d.abs() < EPS){
      return "0.0";
    }
    return d.toStringAsFixed(1);
  }

  static Text createDifferenceText(double a, double b) {
    assert(a != null && b != null);
    String text = "";
    TextStyle style = defaultTextStyle;
    if ((a - b).abs() < EPS) {
      text = "0.0";
    } else {
      if (a > b) {
        text += "+";
        style = greenTextStyle;
      } else {
        style = redTextStyle;
      }
      text += (a - b).toStringAsFixed(1);
    }
    return new Text(text, style: style);
  }

  static String getCurrentProfileName(BuildContext context) {
    return ScopedModel.of<AppModel>(context).getProfile().name;
  }
}
