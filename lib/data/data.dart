import 'package:scheibner_app/algorithm/simulation.dart';
import 'dart:convert';

import 'package:scheibner_app/helpers/database_helpers.dart';

class ReducedData {
  int id;
  DateTime saveDate;

  ReducedData(this.id, this.saveDate);

  ReducedData.fromMap(Map<String, dynamic> map) {
    id = map[colSimId];
    saveDate = DateTime.tryParse(map[colSaveDate]);
  }
}

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
  //TODO: name localization
  static final List<String> showable = names.sublist(0, 14);
  static final List<String> modifiable = showable.sublist(0, 5);
  static final List<String> chartable =
      showable.sublist(modifiable.length, showable.length);

  DateTime _date;
  Map<String, dynamic> _values;

  Data(this._date, this._values, {bool calcAdditional = true}) {
    if (calcAdditional) {
      ScheibnerSimulation.calcAdditionalData(this._values);
    }
  }

  Data.clone(Data data) {
    if (data != null) {
      _values = new Map<String, double>.from(data._values);
      _date = data._date;
    }
  }

  Data.fromJson(String s) {
    Map<String, dynamic> map = json.decode(s);
    _date = DateTime.tryParse(map["date"]);
    _values = map["values"];
  }

  String toJson() => json.encode({
        "date": _date?.toIso8601String(),
        "values": _values,
      });

  void simulate() {
    ScheibnerSimulation.simulate(_values);
  }

  double getValue(String name) {
    return _values[name];
  }

  void setValue(String name, double value) {
    _values[name] = value;
  }
}
