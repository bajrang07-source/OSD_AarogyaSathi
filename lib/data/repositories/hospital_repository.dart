import '../models/hospital_model.dart';
import '../../services/db/database_service.dart';

/// Repository for hospitals table CRUD and queries.
class HospitalRepository {
  HospitalRepository._();
  static final HospitalRepository instance = HospitalRepository._();

  static const String _table = DatabaseService.tableHospitals;

  /// Insert a hospital record. Returns the new row id.
  Future<int> insert(Hospital hospital) async {
    return DatabaseService.instance.insert(_table, hospital.toMap());
  }

  /// Insert multiple hospitals in a single transaction.
  Future<void> insertAll(List<Hospital> hospitals) async {
    final db = await DatabaseService.instance.database;
    final batch = db.batch();
    for (final h in hospitals) {
      batch.insert(_table, h.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Fetch all hospitals, optionally filtered by district.
  Future<List<Hospital>> getAll({String? district}) async {
    final rows = await DatabaseService.instance.query(
      _table,
      where: district != null ? 'district = ?' : null,
      whereArgs: district != null ? [district] : null,
      orderBy: 'name ASC',
    );
    return rows.map(Hospital.fromMap).toList();
  }

  /// Fetch only emergency-capable hospitals.
  Future<List<Hospital>> getEmergency() async {
    final rows = await DatabaseService.instance.query(
      _table,
      where: 'emergency_capable = 1',
      orderBy: 'name ASC',
    );
    return rows.map(Hospital.fromMap).toList();
  }

  /// Search hospitals by name or services.
  Future<List<Hospital>> search(String query) async {
    final like = '%$query%';
    final rows = await DatabaseService.instance.rawQuery(
      'SELECT * FROM $_table WHERE name LIKE ? OR services LIKE ? ORDER BY name ASC',
      [like, like],
    );
    return rows.map(Hospital.fromMap).toList();
  }

  /// Get hospital by id.
  Future<Hospital?> getById(int id) async {
    final rows = await DatabaseService.instance.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Hospital.fromMap(rows.first);
  }

  /// Delete all hospitals (used before re-seeding).
  Future<void> deleteAll() async {
    final db = await DatabaseService.instance.database;
    await db.delete(_table);
  }

  /// Count total hospitals.
  Future<int> count() async {
    final result = await DatabaseService.instance.rawQuery(
      'SELECT COUNT(*) as count FROM $_table',
    );
    return (result.first['count'] as int?) ?? 0;
  }
}
