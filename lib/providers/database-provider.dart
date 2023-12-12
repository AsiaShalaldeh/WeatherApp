import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/city.dart';
import '../models/preference.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider._privateConstructor();

  static final DatabaseProvider instance =
      DatabaseProvider._privateConstructor();
  static Database? _database;
  static const int version = 1;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'weatherDB.db');
    return openDatabase(
      path,
      version: version,
      onCreate: (Database db, int version) async {
        await createCityTable(db);
        await createUserPreferencesTable(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        // Implement upgrade logic if needed
      },
    );
  }

  Future<void> createCityTable(Database db) async {
    await db.execute('''
    CREATE TABLE cities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      city_name TEXT,
      city_image TEXT
    )
  ''');
  }

  Future<void> createUserPreferencesTable(Database db) async {
    await db.execute('''
    CREATE TABLE preferences (
      selected_city_id INTEGER PRIMARY KEY,
      FOREIGN KEY (selected_city_id) REFERENCES cities (id)
    )
  ''');
  }

  void insertCity(City city) async {
    final db = await database;
    await db.insert('cities', city.toMap());
    notifyListeners();
  }

  void deleteCity(int id) async {
    final db = await database;
    db.delete('cities', where: 'id=?', whereArgs: [id]);
    notifyListeners();
  }

  Future<List<City>> getAllCities() async {
    final db = await database;
    List<Map<String, dynamic>> records = await db.query('cities');
    List<City> cities = [];
    for (var record in records) {
      City city = City.fromMap(record);
      cities.add(city);
    }
    return cities;
  }

  void insertPreference(Preference preference) async {
    final db = await database;
    await db.insert('preferences', preference.toMap());
    notifyListeners();
  }

  void deletePreference(int id) async {
    final db = await database;
    db.delete('preferences', where: 'id=?', whereArgs: [id]);
    notifyListeners();
  }

  Future<List<Preference>> getUserPreferences() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('preferences');
    List<Preference> preferences = [];
    for (var record in result) {
      Preference preference = Preference.fromMap(record);
      preferences.add(preference);
    }
    return preferences;
  }
}
