import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ScheibnerSim/data/data.dart';
import 'package:ScheibnerSim/data/profile.dart';
import 'package:ScheibnerSim/pages/profilePage.dart';
import 'package:sqflite/sqflite.dart';

// database table and column names
final String tableProfiles = 'profiles';
final String colProfileId = '_id';
final String colProfileName = 'name';
final String colLastChanged = 'lastChanged';
final String colServerId = 'serverId';
final String colMeasDataContent = 'measurementContent';
final String colSimDataContent = 'simulationContent';
final String colComment = 'comment';

///singleton class to manage the database
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

  ///opens the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  ///SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableProfiles (
                $colProfileId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $colProfileName TEXT NOT NULL,
                $colLastChanged TEXT,
                $colServerId INTEGER,
                $colMeasDataContent TEXT,
                $colSimDataContent TEXT,
                $colComment TEXT
              );
              ''');
  }

  ///creates a profile for a given [name]
  Future<int> createProfile(String name) async {
    Database db = await database;
    int id = await db.insert(tableProfiles, new Profile(name).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  ///inserts a given profile [p]
  Future<int> insertProfile(Profile p) async {
    Database db = await database;
    int id = await db.insert(tableProfiles, p.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  ///deletes the profile for a given [id]
  Future<bool> deleteProfile(int id) async {
    Database db = await database;
    int count = await db
        .delete(tableProfiles, where: "$colProfileId = ?", whereArgs: [id]);
    return count > 0;
  }

  ///deletes a profiles
  Future<bool> deleteAllProfiles() async {
    Database db = await database;
    int count = await db.delete(tableProfiles);
    return count > 0;
  }

  ///drops all tables
  Future dropAllTables() async {
    Database db = await database;
    await db.execute('''
        DROP TABLE $tableProfiles;
    ''');
  }

  ///loads profile for given [id]
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
    return profile;
  }

  ///updates the colLastChanged of profile for [id]
  Future<bool> updateProfileLastChanged(int id, DateTime date) async {
    Database db = await database;
    int count = await db.update(
        tableProfiles, {colLastChanged: date.toIso8601String()},
        where: "$colProfileId = ?", whereArgs: [id]);
    return count > 0;
  }

  ///saves [profile] to database
  Future<bool> saveProfile(Profile profile) async {
    Database db = await database;
    int count = await db.update(tableProfiles, profile.toMap(), where: "$colProfileId = ?", whereArgs: [profile.id]);
    updateProfileLastChanged(profile.id, DateTime.now());
    return count > 0;
  }

  ///changes profilename for a given profile with a given [id] to name [name]
  Future<bool> changeProfileName(int id, String name) async {
    Database db = await database;
    int count = await db.update(tableProfiles, {colProfileName: name},
        where: "$colProfileId = ?", whereArgs: [id]);
    updateProfileLastChanged(id, DateTime.now());
    return count > 0;
  }

  ///changes servedId for a given profile with a given [profileId] to serverId [serverId]
  Future<bool> changeServerId(int profileId, int serverId) async {
    Database db = await database;
    int count = await db.update(tableProfiles, {colServerId: serverId},
        where: "$colProfileId = ?", whereArgs: [profileId]);
    updateProfileLastChanged(profileId, DateTime.now());
    return count > 0;
  }

  ///changes measurement Data for a given profile with a given [id] to Data [meas]
  Future<bool> changeMeasData(int id, Data meas) async {
    Database db = await database;
    String content = meas.toJson();
    int count = await db.update(tableProfiles, {colMeasDataContent: content},
        where: "$colProfileId = ?", whereArgs: [id]);
    updateProfileLastChanged(id, DateTime.now());
    return count > 0;
  }

  ///changes simulatiom data for a given profile with a given [id] to Data [sim]
  Future<bool> changeSimData(int id, Data sim) async {
    Database db = await database;
    String content = sim.toJson();
    int count = await db.update(tableProfiles, {colSimDataContent: content},
        where: "$colProfileId = ?", whereArgs: [id]);
    updateProfileLastChanged(id, DateTime.now());
    return count > 0;
  }

  ///returns a reduced profile list
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
