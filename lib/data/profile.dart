import 'package:ScheibnerSim/helpers/database_helpers.dart';

import 'data.dart';

///class Profile
class Profile {
  int id;
  String name;
  DateTime lastChanged;
  int serverId;
  // measurement data
  Data meas;
  // simulation data
  Data sim;
  String comment;

  ///constructor for Profile
  Profile(this.name, {this.serverId, this.meas, this.sim}) {
    lastChanged = DateTime.now();
  }

  ///constructor for Profile from a map
  Profile.fromMap(Map<String, dynamic> map) {
    id = map[colProfileId];
    name = map[colProfileName];
    lastChanged = DateTime.tryParse(map[colLastChanged]);
    serverId = map[colServerId];
    if (map[colMeasDataContent] != null) {
      meas = Data.fromJson(map[colMeasDataContent]);
    }
    if (map[colSimDataContent] != null) {
      sim = Data.fromJson(map[colSimDataContent]);
    }
    comment = map[colComment];
  }

  ///returns a map, specifieing all data
  Map<String, dynamic> toMap() => {
        // colProfileId: id,
        colProfileName: name,
        colLastChanged: lastChanged?.toIso8601String(),
        colServerId: serverId,
        colMeasDataContent: meas?.toJson(),
        colSimDataContent: sim?.toJson(),
        colComment: comment,
      };
}
