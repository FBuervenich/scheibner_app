import 'package:ScheibnerSim/algorithm/simulation.dart';
import 'dart:convert';

class ValueInfo {
  String name;
  String unit;
  double lowerBound;
  double upperBound;

  ValueInfo.modifiable(this.name, this.unit, this.lowerBound, this.upperBound)
  {
    assert(lowerBound <= upperBound);
  }
  ValueInfo.showable(this.name, this.unit);
  ValueInfo(this.name);
}

class Data {
  static final List<ValueInfo> allValues = <ValueInfo>[
    ValueInfo.modifiable("radumfang_vorn", "mm", 1700, 2200),
    ValueInfo.modifiable("radumfang_hinten", "mm", 1700, 2200),
    ValueInfo.modifiable("gabellaenge", "mm", 400, 1200),
    ValueInfo.modifiable("heckhoehe", "mm", 200, 1200),
    ValueInfo.modifiable("schwingenlaenge", "mm", 400, 700),
    ValueInfo.showable("lkwgrad", "°"),
    ValueInfo.showable("nachlauf", "mm"),
    ValueInfo.showable("offset", "mm"),
    ValueInfo.showable("schwingenwinkel_grad", "°"),
    ValueInfo.showable("radstand", "mm"),
    ValueInfo.showable("vorderbauhoehe", "mm"),
    ValueInfo.showable("vorderachshoehe_read", "mm"),
    ValueInfo.showable("schwingenachshoehe", "mm"),
    ValueInfo.showable("hinterachshoehe_read", "mm"),
    ValueInfo("g_st"),
    ValueInfo("g_Rw"),
    ValueInfo("g_Rl"),
    ValueInfo("cmd_winkel"),
    ValueInfo("g_Lv"),
    ValueInfo("c1"),
    ValueInfo("c2"),
    ValueInfo("c3"),
    ValueInfo("c4"),
    ValueInfo("c5"),
    ValueInfo("c6"),
    ValueInfo("c7"),
    ValueInfo("c8"),
    ValueInfo("nachlauf_real"),
    ValueInfo("abstand_vorn_read"),
    ValueInfo("abstand_hinten_read"),
  ];
  static final List<ValueInfo> showable = allValues.sublist(0, 14);
  static final List<ValueInfo> modifiable = showable.sublist(0, 5);
  static final List<ValueInfo> chartable =
      showable.sublist(modifiable.length, showable.length);
  static final Map<String, ValueInfo> valueInfo =
      Map.fromIterable(allValues, key: (v) => v.name, value: (v) => v);

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
