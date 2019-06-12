import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/helpers/scheibnerException.dart';

class ApiService {
  Future<Data> getMeasurementFromId(int id) async {
    final response = await http.get(
        'http://krisc.luca-student.be/scheibner/messung.php?id=' +
            id.toString());
    if (response.statusCode != 200) {
      throw new ScheibnerException("errorDataLoading");
    }
    final jsonResponse = json.decode(response.body);
    return this._createMeasurementFromJson(jsonResponse);
  }

  Data getMeasurementFromJson(String jsonString) {
    try {
      Map<String, dynamic> map = json.decode(jsonString);
      return this._createMeasurementFromJson(json.decode(jsonString));
    } catch (e) {
      throw new ScheibnerException("errorJsonParsing");
    }
  }

  Data _createMeasurementFromJson(Map<String, dynamic> json) {
    String error = this._checkIfObjIsValid(json);
    if (error != null) {
      throw new ScheibnerException("errorJsonParsing");
    }

    Map<String, double> values = {};
    values["radumfang_vorn"] = (json['radumfang_vorn'] as int).toDouble();
    values["radumfang_hinten"] = (json['radumfang_hinten'] as int).toDouble();
    values["abstand_vorn_read"] = (json['abstand_vorn_read'] as int).toDouble();
    values["vorderachshoehe_read"] =
        (json['vorderachshoehe_read'] as int).toDouble();
    values["abstand_hinten_read"] =
        (json['abstand_hinten_read'] as int).toDouble();
    values["hinterachshoehe_read"] =
        (json['hinterachshoehe_read'] as int).toDouble();
    values["heckhoehe"] = (json['heckhoehe'] as int).toDouble();
    values["offset"] = json['offset'] as double;
    values["g_st"] = json['g_st'] as double;
    values["g_rw"] = json['g_rw'] as double;
    values["g_rl"] = json['g_rl'] as double;
    values["cmd_winkel"] = (json['cmd_winkel'] as int).toDouble();
    values["g_lv"] = json['g_lv'] as double;
    values["c1"] = (json['c1'] as int).toDouble();
    values["c2"] = (json['c2'] as int).toDouble();
    values["c3"] = (json['c3'] as int).toDouble();
    values["c4"] = (json['c4'] as int).toDouble();
    values["c5"] = (json['c5'] as int).toDouble();
    values["c6"] = (json['c6'] as int).toDouble();
    values["c7"] = (json['c7'] as int).toDouble();
    values["c8"] = (json['c8'] as int).toDouble();

    DateTime date = DateTime.now();
    Data data = new Data(date, values);
    return data;
  }

  String _checkIfObjIsValid(Map<String, dynamic> json) {
    var keys = [
      "radumfang_vorn",
      "radumfang_hinten",
      "abstand_vorn_read",
      "vorderachshoehe_read",
      "abstand_hinten_read",
      "hinterachshoehe_read",
      "heckhoehe",
      "offset",
      "g_st",
      "g_rw",
      "g_rl",
      "cmd_winkel",
      "g_Lv",
      "c1",
      "c2",
      "c3",
      "c4",
      "c5",
      "c6",
      "c7",
      "c8"
    ];

    for (String key in keys) {
      if (!json.containsKey(key)) {
        return key;
      }
    }

    return null;
  }
}
