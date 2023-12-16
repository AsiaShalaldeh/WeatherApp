import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
        await createUserPreferencesTable(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        // Implement upgrade logic if needed
      },
    );
  }

  Future<void> createUserPreferencesTable(Database db) async {
    await db.execute('''
    CREATE TABLE preferences (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      city_name TEXT
    )
  ''');
  }

  Future<void> insertPreference(Preference preference) async {
    final db = await database;
    try {
      await db.insert('preferences', preference.toMap());
      print('Insert success: $preference');
      notifyListeners();
    } catch (e) {
      print('Insert error: $e');
    }
  }

  Future<void> deletePreference(String cityName) async {
    final db = await database;
    db.delete('preferences', where: 'city_name=?', whereArgs: [cityName]);
    notifyListeners();
  }

  Future<bool> isFavorite(String cityName) async {
    try {
      final preferences = await DatabaseProvider.instance.getUserPreferences();
      return preferences.any((preference) => preference.cityName == cityName);
    } catch (error) {
      print('Error checking favorite status: $error');
      return false;
    }
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
