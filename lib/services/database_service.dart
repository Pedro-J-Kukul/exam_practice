// File: lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'dart:async';

// multiple_choice_questions table creation statement
const String createMultipleChoiceQuestionsTable = '''
CREATE TABLE multiple_choice_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question TEXT NOT NULL,
  option_correct TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  explanation TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
''';

// A service class to handle database operations
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createMultipleChoiceQuestionsTable);
        Logger().i('Database and multiple_choice_questions table created');
      },
    );
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
    Logger().i('Database connection closed');
  }

  // Delete the database
  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    await deleteDatabase(path);
    Logger().i('Database file deleted');
  }

  // Upgrade the database
  Future<void> upgradeDatabase(
    int oldVersion,
    int newVersion,
    String query,
  ) async {
    final db = await database;
    if (oldVersion < newVersion) {
      await db.execute(query);
      Logger().i('Database upgraded from version $oldVersion to $newVersion');
    }
  }
}
