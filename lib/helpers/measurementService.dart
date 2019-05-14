import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scheibner_app/data/data.dart';

class ApiService {
  Future<Data> getMeasurementFromId(int id) async {
    final response = await http.get(
        'http://krisc.luca-student.be/scheibner/cms.php?id=' + id.toString());
    if (response.statusCode != 200) {
      throw new Exception(); //TODO specify error
    }
    final jsonResponse = json.decode(response.body);
    return this._createMeasurementFromJson(jsonResponse);
  }

  Data getMeasurementFromJson(String jsonString) {
    return this._createMeasurementFromJson(json.decode(jsonString));
  }

  Data _createMeasurementFromJson(Map<String, double> json) {
    String error = this._checkIfObjIsValid(json);
    if (error != null) {
      throw new Exception(); //TODO specify error (pass error)
    }
    Data d = new Data();

    d.radumfangVorn = json['radumfangVorn'];
    d.radumfangHinten = json['radumfangHinten'];
    d.abstandVorn = json['abstandVorn'];
    d.vorderachshoehe = json['vorderachshoehe'];
    d.abstandHinten = json['abstandHinten'];
    d.hinterachshoehe = json['hinterachshoehe'];
    d.heckhoehe = json['heckhoehe'];
    d.offset = json['offset'];
    d.gSt = json['gSt'];
    d.gRw = json['gRw'];
    d.gRl = json['gRl'];
    d.cmdWinkel = json['cmdWinkel'];
    d.gLv = json['gLv'];
    d.c1 = json['c1'];
    d.c2 = json['c2'];
    d.c3 = json['c3'];
    d.c4 = json['c4'];
    d.c5 = json['c5'];
    d.c6 = json['c6'];
    d.c7 = json['c7'];
    d.c8 = json['c8'];

    return d;
  }

  String _checkIfObjIsValid(Map<String, double> json) {
    var keys = ["radumfangVorn", 
      "radumfangHinten",
      "abstandVorn",
      "vorderachshoehe",
      "abstandHinten",
      "hinterachshoehe",
      "heckhoehe",
      "offset",
      "gSt",
      "gRw",
      "gRl",
      "cmdWinkel",
      "gLv",
      "c1",
      "c2",
      "c3",
      "c4",
      "c5",
      "c6",
      "c7",
      "c8",
    ];

    for(String key in keys){
      if(!json.containsKey(key)){
        	return key;
      }
    }

    return null;
  }
}
