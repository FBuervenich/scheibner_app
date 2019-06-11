import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';

class Helper {
  static const EPS = 5e-2;

  static String valToString(double d) {
    return d != null ? d.toStringAsFixed(1) : "Null";
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
