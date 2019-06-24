import 'dart:collection';

import 'package:scoped_model/scoped_model.dart';

///Manages all available profiles
class ProfileList extends Model {
  HashMap<int, String> _profiles;

  ///Init the profile list and fill it with data from the server
  ProfileList() {
    _profiles = new HashMap<int, String>();
  }

  ///returns all prpfiles
  HashMap<int, String> getProfiles() {
    return _profiles;
  }

  ///adds a profile for a given [id] and [name]
  void addProfile(int id, String name) {
    _profiles[id] = name;
    notifyListeners();
  }

  ///deletes profile for id [id]
  void deleteProfile(int id) {
    _profiles.remove(id);
    notifyListeners();
  }
}