import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Singleton SQLite database service.
/// Phase 0: Creates empty table stubs.
/// Phase 1: Seeds real data via migration.
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  static const String _dbName = 'aarogya_sathi.db';
  static const int _dbVersion = 1;

  // ── Table names ───────────────────────────────────────────────────────────
  static const String tableHospitals = 'hospitals';
  static const String tableFirstAidTopics = 'first_aid_topics';
  static const String tableTransportContacts = 'transport_contacts';
  static const String tableHealthCard = 'health_card';
  static const String tableTriageLogs = 'triage_logs';
  static const String tableMedicationReminders = 'medication_reminders';
  static const String tableFavorites = 'favorites';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<void> initialize() async {
    await database;
    debugPrint('[DatabaseService] Initialized — version $_dbVersion');
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  /// Enable WAL mode and foreign keys
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('PRAGMA journal_mode = WAL');
  }

  /// Schema v1 — all tables created here.
  /// Phase 1 will populate data via seed methods.
  Future<void> _onCreate(Database db, int version) async {
    debugPrint('[DatabaseService] Creating schema v$version');

    // ── hospitals ──────────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableHospitals (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        name            TEXT NOT NULL,
        type            TEXT NOT NULL,
        lat             REAL NOT NULL,
        lng             REAL NOT NULL,
        address         TEXT,
        phone           TEXT,
        district        TEXT,
        services        TEXT,   -- JSON array of service strings
        emergency_capable INTEGER NOT NULL DEFAULT 0,
        beds            INTEGER,
        last_synced     INTEGER  -- Unix timestamp
      )
    ''');

    // ── first_aid_topics ───────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableFirstAidTopics (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        condition       TEXT NOT NULL,
        steps           TEXT NOT NULL,  -- JSON array of step strings
        warnings        TEXT,           -- JSON array of warning strings
        severity_tags   TEXT,           -- JSON array: ['Critical','emergency']
        search_keywords TEXT,
        created_at      INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');

    // ── transport_contacts ─────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableTransportContacts (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        name            TEXT NOT NULL,
        type            TEXT NOT NULL,  -- ambulance | auto | volunteer | driver
        phone           TEXT NOT NULL,
        area            TEXT,
        is_24x7         INTEGER NOT NULL DEFAULT 0,
        vehicle_type    TEXT,
        notes           TEXT
      )
    ''');

    // ── health_card ────────────────────────────────────────────────────────
    // Phase 11: will use encrypted fields (sqlcipher / flutter_secure_storage)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableHealthCard (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        name                TEXT,
        age                 INTEGER,
        blood_group         TEXT,
        allergies           TEXT,             -- JSON array
        chronic_conditions  TEXT,             -- JSON array
        medications         TEXT,             -- JSON array
        emergency_contacts  TEXT,             -- JSON array of objects
        pin_hash            TEXT,
        updated_at          INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');

    // ── triage_logs ────────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableTriageLogs (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        symptoms        TEXT NOT NULL,        -- JSON array
        severity        TEXT NOT NULL,        -- Low|Moderate|High|Critical
        reasoning       TEXT,
        action_taken    TEXT,
        created_at      INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');

    // ── medication_reminders ───────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableMedicationReminders (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        medication_name TEXT NOT NULL,
        dosage          TEXT,
        schedule        TEXT NOT NULL,        -- JSON schedule object
        is_active       INTEGER NOT NULL DEFAULT 1,
        created_at      INTEGER NOT NULL DEFAULT (strftime('%s','now'))
      )
    ''');

    // ── favorites ──────────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableFavorites (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        item_type       TEXT NOT NULL,        -- first_aid | hospital
        item_id         INTEGER NOT NULL,
        saved_at        INTEGER NOT NULL DEFAULT (strftime('%s','now')),
        UNIQUE(item_type, item_id)
      )
    ''');

    debugPrint('[DatabaseService] Schema created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('[DatabaseService] Upgrading from v$oldVersion to v$newVersion');
    // Future migrations go here
  }

  // ── Generic helpers ───────────────────────────────────────────────────────

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await database;
    return db.insert(table, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> row, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return db.update(table, row, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return db.rawQuery(sql, arguments);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
