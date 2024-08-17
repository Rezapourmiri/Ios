import 'dart:async';
import 'package:optima_soft/models/mission_location_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCrudService {
  DatabaseCrudService.ensureInitialized();

  static final DatabaseCrudService _instance = DatabaseCrudService._internal();

  factory DatabaseCrudService() {
    return _instance;
  }

  DatabaseCrudService._internal();

  final String missionLocationTable = 'MissionLocationTable';
  final String missionLocationId = 'missionLocationId';
  final String personTourId = 'personTourId';
  final String latitude = 'latitude';
  final String longitude = 'longitude';
  final String momentSpeed = 'momentSpeed';
  final String createLocationAt = 'createLocationAt';
  final String updateLocationAt = 'updateLocationAt';

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db
          // never read but i have to write bec _db is nullable
          ??
          await initDb();
    }
    _db = await initDb();
    return _db
        // never read but i have to write bec _db is nullable
        ??
        await initDb();
  }

  initDb() async {
    String path = join(await getDatabasesPath(), "Optimasoft.payroll.db");
    // share_p.saveDbPath(path);

    var ourDb = await openDatabase(path,
        version: 3, onCreate: _onCreate, onUpgrade: _onUpgrade);
    // ourDb.execute("DROP TABLE $missionLocationTable");
    // await ourDb.execute(
    //     "CREATE TABLE $missionLocationTable($missionLocationId INTEGER PRIMARY KEY AUTOINCREMENT, $personTourId INTEGER, $latitude REAL, $longitude REAL, $createLocationAt TEXT, $updateLocationAt TEXT)");
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    db.execute("DROP TABLE IF EXISTS $missionLocationTable");
    await db.execute(
        "CREATE TABLE $missionLocationTable($missionLocationId INTEGER PRIMARY KEY AUTOINCREMENT, $personTourId INTEGER, $latitude REAL, $longitude REAL, $createLocationAt TEXT, $updateLocationAt TEXT, $momentSpeed REAL)");
  }

  // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion == 2 && newVersion == 3) {
      db.execute(
          "ALTER TABLE $missionLocationTable ADD COLUMN $momentSpeed REAL;");
    }
  }

  Future<int> saveMissoinLocation(MissionLocation item) async {
    Database dbClient = await db;
    int res = await dbClient.insert(missionLocationTable, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<void> clearAllMissoinLocation() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE FROM $missionLocationTable");
  }

  Future<void> clearAllMissoinLocationByLastItemId(int lastItemId) async {
    Database dbClient = await db;
    await dbClient.execute(
        "DELETE FROM $missionLocationTable WHERE $missionLocationId <= $lastItemId");
  }

  Future<void> clearAllMissoinLocationExeptPersonTourId(
      int inputpersonTourId, int lastItemId) async {
    Database dbClient = await db;
    await dbClient.execute(
        "DELETE FROM $missionLocationTable WHERE $personTourId != $inputpersonTourId AND $missionLocationId <= $lastItemId");
  }

  Future<List<MissionLocation>> getAllMissionLocationBypersonTourIdWithMap(
      int inputpersonTourId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM $missionLocationTable WHERE $personTourId = $inputpersonTourId');
    List<MissionLocation> newList = [];
    for (var element in res) {
      newList.add(MissionLocation.fromMap(element));
    }
    return newList;
  }

  Future<List<MissionLocation>> getAllMissionLocationWithMap() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM $missionLocationTable');
    List<MissionLocation> newList = [];
    for (var element in res) {
      newList.add(MissionLocation.fromMap(element));
    }
    return newList;
  }

  Future<MissionLocation> getMissionLocationByIdWithMap(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM $missionLocationTable WHERE $missionLocationId = $id');
    return MissionLocation.fromMap(res.first);
  }

  Future<List<Map<String, dynamic>>> getAllMissionLocationByPersonTourId(
      int inputpersonTourId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM $missionLocationTable WHERE $personTourId = $inputpersonTourId');

    return res.toList();
  }

  Future<List<Map<String, dynamic>>> getAllMissionLocationExeptPersonTourId(
      int inputpersonTourId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM $missionLocationTable WHERE $personTourId = $inputpersonTourId');

    return res.toList();
  }

  Future<List<Map<String, dynamic>>> getAllMissionLocation() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM $missionLocationTable');

    return res.toList();
  }

  Future<Map<String, dynamic>> getMissionLocationById(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM $missionLocationTable WHERE $missionLocationId = $id');
    return res.first;
  }

  Future<int> deleteMissionLocation(int id) async {
    var dbClient = await db;
    return await dbClient.delete(missionLocationTable,
        where: '$missionLocationId = ?', whereArgs: [id]);
  }

  Future<int> updateMissionLocation(MissionLocation item) async {
    var dbClient = await db;
    return await dbClient.update(missionLocationTable, item.toMap(),
        where: "$missionLocationId = ?", whereArgs: [item.missionLocationId]);
  }
  //endregion

  // Future<String?> backup() async {
  //   Directory? directory = await getExternalStorageDirectory();
  //   String? copyPath;
  //   if (directory != null) {
  //     String path = join(directory.path, 'backup');
  //     Directory directoryB = Directory(path);
  //     bool exist = directoryB.existsSync();
  //     if (!exist) {
  //       directoryB.createSync(recursive: true);
  //     }
  //     File databaseToCopy = File(dbPath);
  //     copyPath = path + '/backup.db';
  //     share_p.saveBackupPath(copyPath);
  //     databaseToCopy.copySync(copyPath);
  //   }
  //   return copyPath;
  // }

  // Future<bool> restore() async {
  //   File fileToCopy = File(backupPath);
  //   try {
  //     fileToCopy.copySync(dbPath);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
