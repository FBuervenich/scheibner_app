import 'package:flutter/widgets.dart';
import 'package:scheibner_app/algorithm/simulation.dart';

class Data {
  static const List<String> names = <String>[
    "radumfang_vorn",
    "radumfang_hinten",
    "gabellaenge",
    "heckhoehe",
    "schwingenlaenge",
    "lkwgrad",
    "nachlauf",
    "offset",
    "schwingenwinkel_grad",
    "radstand",
    "vorderbauhoehe",
    "vorderachshoehe_read",
    "schwingenachshoehe",
    "hinterachshoehe_read",
    "g_st",
    "g_Rw",
    "g_Rl",
    "cmd_winkel",
    "g_Lv",
    "c1",
    "c2",
    "c3",
    "c4",
    "c5",
    "c6",
    "c7",
    "c8",
    "nachlauf_real",
    "abstand_vorn_read",
    "abstand_hinten_read",
  ];
  //TODO: review showable and editable values
  //TODO: name localization
  static final List<String> showable = names.sublist(0, 14);
  static final List<String> modifiable = showable.sublist(0, 5);

  DateTime _date;
  Map<String, double> _values;

  Data(this._date, this._values) {
    ScheibnerSimulation scheibnersim = new ScheibnerSimulation();
    scheibnersim.calcAdditionalData(this._values);
  }

  // creates random data for testing
  Data.testData() {
    _values = <String, double>{};
    for (int i = 0; i < names.length; i++) {
      String name = names[i];
      _values[name] = i + 1000.01234;
    }
    _date = new DateTime.now();
  }

  Data.clone(Data data) {
    if (data != null) {
      _values = new Map<String, double>.from(data._values);
      _date = data._date;
    }
  }

  double getValue(String name) {
    return _values[name];
  }

  void setValue(String name, double value) {
    _values[name] = value;
  }
}

// List<NameValuePair> getShowableValues() {
//   return [
//     NameValuePair("radumfangVorn", radumfangVorn),
//     NameValuePair("radumfangHinten", radumfangHinten),
//     NameValuePair("gabellaenge", gabellaenge),
//     NameValuePair("heckhoehe", heckhoehe),
//     NameValuePair("schwingenlaenge", schwingenlaenge),
//     NameValuePair("lkwgrad", lkwGrad),
//     NameValuePair("nachlauf", nachlauf),
//     NameValuePair("offset", offset),
//     NameValuePair("schwingenwinkelGrad", schwingenwinkelGrad),
//     NameValuePair("radstand", radstand),
//     // NameValuePair("vorderbauhoehe", vorderbauhoehe), //TODO is not calculated yet
//     NameValuePair("vorderachshoehe", vorderachshoehe),
//     // NameValuePair("schwingenachshoehe", schwingenachshoehe), //TODO is not calculated yet
//     NameValuePair("hinterachshoehe", hinterachshoehe),

//     // abstandVorn,
//     // abstandHinten,
//     // cmdWinkel,
//     // nachlaufReal,
//   ];
// }
