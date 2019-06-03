import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/data/profile.dart';
import 'package:scheibner_app/pages/profilePage.dart';
import 'package:sqflite/sqflite.dart';

// database table and column names
final String tableProfiles = 'profiles';
final String colProfileId = '_id';
final String colProfileName = 'name';
final String colLastChanged = 'lastChanged';
final String colServerId = 'serverId';
final String colMeasDataContent = 'measurementContent';

final String tableSimData = 'simulationData';
final String colSimId = '_id';
final String colSaveDate = 'saveDate';
final String colSimDataContent = 'simulationContent';
final String colForeignProfile = 'profileId';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 3;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableProfiles (
                $colProfileId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $colProfileName TEXT NOT NULL,
                $colLastChanged TEXT,
                $colServerId INTEGER,
                $colMeasDataContent TEXT
              );
              ''');
    await db.execute('''
              CREATE TABLE $tableSimData (
                $colSimId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $colSimDataContent TEXT NOT NULL,
                $colSaveDate TEXT,
                $colForeignProfile INTEGER NOT NULL,
                FOREIGN KEY ($colForeignProfile) REFERENCES $tableProfiles ($colProfileId)
                ON DELETE CASCADE
              );
              ''');
  }

  // Database helper methods:

  Future<int> createProfile(String name) async {
    Database db = await database;
    int id = await db.insert(tableProfiles, new Profile(name).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }
  Future<int> insertProfile(Profile p) async {
    Database db = await database;
    int id = await db.insert(tableProfiles, p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<bool> deleteProfile(int id) async {
    Database db = await database;
    int count = await db
        .delete(tableProfiles, where: "$colProfileId = ?", whereArgs: [id]);
    return count > 0;
  }

  Future<bool> deleteAllProfiles() async {
    Database db = await database;
    int count = await db.delete(tableProfiles);
    return count > 0;
  }

  Future dropAllTables() async {
    Database db = await database;
    await db.execute('''
        DROP TABLE $tableProfiles;
        DROP TABLE $tableSimData;
    ''');
  }

  Future<Profile> loadProfile(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableProfiles,
      columns: ["*"],
      where: "$colProfileId = ?",
      whereArgs: [id],
    );
    if (result.isEmpty) {
      return null; // profile does not exist;
    }
    Profile profile = new Profile.fromMap(result.first);
    result = await db.query(
      tableSimData,
      columns: [colSimDataContent],
      where: "$colForeignProfile = ?",
      whereArgs: [profile.id],
      orderBy: "$colSaveDate DESC",
      limit: 1,
    );
    if (result.isNotEmpty) {
      Data sim = Data.fromJson(result.first[colSimDataContent]);
      profile.sim = sim;
    }
    updateProfileLastChanged(id, DateTime.now());
    return profile;
  }

  Future<bool> updateProfileLastChanged(int id, DateTime date) async {
    Database db = await database;
    int count = await db.update(tableProfiles, {colLastChanged: date.toIso8601String()},
        where: "$colProfileId = ?", whereArgs: [id]);
    return count > 0;
  }

  Future<bool> changeProfileName(int id, String name) async {
    Database db = await database;
    int count = await db.update(tableProfiles, {colProfileName: name},
        where: "$colProfileId = ?", whereArgs: [id]);
    return count > 0;
  }

  Future<bool> changeServerId(int profileId, int serverId) async {
    Database db = await database;
    int count = await db.update(tableProfiles, {colServerId: serverId},
        where: "$colProfileId = ?", whereArgs: [profileId]);
    return count > 0;
  }

  Future<bool> changeMeasData(int id, Data meas) async {
    Database db = await database;
    String content = meas.toJson();
    int count = await db.update(tableProfiles, {colMeasDataContent: content},
        where: "$colProfileId = ?", whereArgs: [id]);
    return count > 0;
  }

  Future<int> addSimData(int profileId, Data sim) async {
    Database db = await database;
    String content = sim.toJson();
    String saveDate = DateTime.now().toIso8601String();
    int simDataId = await db.insert(tableSimData, {
      colSaveDate: saveDate,
      colSimDataContent: content,
      colForeignProfile: profileId,
    });
    return simDataId;
  }

  Future<Data> loadSimData(int simId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableSimData,
      columns: [colSimDataContent],
      where: "$colSimId = ?",
      whereArgs: [simId],
    );
    Data sim = Data.fromJson(result.first[colSimDataContent]);
    return sim;
  }

  Future<List<ReducedData>> getSimDataList(int profileId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableSimData,
      columns: [colSimId, colSaveDate],
      where: "$colForeignProfile = ?",
      whereArgs: [profileId],
      orderBy: "$colSaveDate DESC",
    );
    return result
        .map((Map<String, dynamic> map) => ReducedData.fromMap(map))
        .toList();
  }

  Future<List<ReducedProfile>> getRedProfileList() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableProfiles,
      columns: [colProfileId, colProfileName, colLastChanged],
      orderBy: "$colLastChanged DESC",
    );
    return result
        .map((Map<String, dynamic> map) => ReducedProfile.fromMap(map))
        .toList();
  }
}
