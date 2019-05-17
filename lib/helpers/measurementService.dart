import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/helpers/scheibnerException.dart';

class ApiService {
  Future<Data> getMeasurementFromId(int id) async {
    final response = await http.get(
        'http://krisc.luca-student.be/scheibner/cms.php?id=' + id.toString());
    if (response.statusCode != 200) {
      throw new ScheibnerException("errorDataLoading");
    }
    final jsonResponse = json.decode(response.body);
    return this._createMeasurementFromJson(jsonResponse);
  }

  Data getMeasurementFromJson(String jsonString) {
    try{
      Map<String, dynamic> map = json.decode(jsonString)
      return this._createMeasurementFromJson(json.decode(jsonString));
    }
    catch (e){
      throw new ScheibnerException("errorJsonParsing"); 
    }
  }

  Data _createMeasurementFromJson(Map<String, dynamic> json) {
    String error = this._checkIfObjIsValid(json);
    if (error != null) {
      throw new ScheibnerException("errorJsonParsing");
    }
    Data d = new Data();

    d.radumfangVorn = (json['radumfang_vorn']  as int).toDouble();
    d.radumfangHinten = (json['radumfang_hinten'] as int).toDouble();
    d.abstandVorn = (json['abstand_vorn_read'] as int).toDouble();
    d.vorderachshoehe = (json['vorderachshoehe_read'] as int).toDouble();
    d.abstandHinten = (json['abstand_hinten_read'] as int).toDouble();
    d.hinterachshoehe = (json['hinterachshoehe_read'] as int).toDouble();
    d.heckhoehe = (json['heckhoehe'] as int).toDouble();
    d.offset = json['offset'] as double;
    d.gSt = json['gSt'] as double;
    d.gRw = json['gRw'] as double;
    d.gRl = json['gRl'] as double;
    d.cmdWinkel = json['cmdWinkel'] as double;
    d.gLv = json['gLv'] as double;
    d.c1 = (json['c1'] as int).toDouble();
    d.c2 = (json['c2'] as int).toDouble();
    d.c3 = (json['c3'] as int).toDouble();
    d.c4 = (json['c4'] as int).toDouble();
    d.c5 = (json['c5'] as int).toDouble();
    d.c6 = (json['c6'] as int).toDouble();
    d.c7 = (json['c7'] as int).toDouble();
    d.c8 = (json['c8'] as int).toDouble();

    return d;
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
