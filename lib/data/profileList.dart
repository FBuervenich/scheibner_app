import 'dart:collection';

import 'package:scoped_model/scoped_model.dart';

// /**
//  * Reduced version of the original profile class.
//  * Contains only {id} and {name}, data is NOT included.
//  */
// class ReducedProfile {
//   int id;
//   String name;
// }

/**
 * Manages all available profiles
 */
class ProfileList extends Model {
  HashMap<int, String> _profiles;

  /**
   * Init the profile list and fill it with data from the server
   */
  ProfileList() {
    _profiles = new HashMap<int, String>();
  }

  HashMap<int, String> getProfiles() {
    return _profiles;
  }

  void addProfile(int id, String name) {
    _profiles[id] = name;
    notifyListeners();
  }

  void deleteProfile(int id) {
    _profiles.remove(id);
    notifyListeners();
  }
}

// class ProfileListModel extends Model {
//   ProfileList _profileList = new ProfileList(); //TODO for testing

//   ProfileListModel() {
//     _profileList = new ProfileList();
//   }

//   ProfileList getProfiles() {
//     return _profileList;
//   }

//   void addProfile() {}
// }
