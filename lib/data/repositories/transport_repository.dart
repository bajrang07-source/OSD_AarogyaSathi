import '../models/transport_contact_model.dart';
import '../../services/db/database_service.dart';

/// Repository for transport_contacts table.
class TransportRepository {
  TransportRepository._();
  static final TransportRepository instance = TransportRepository._();

  static const String _table = DatabaseService.tableTransportContacts;

  Future<int> insert(TransportContact contact) async {
    return DatabaseService.instance.insert(_table, contact.toMap());
  }

  Future<void> insertAll(List<TransportContact> contacts) async {
    final db = await DatabaseService.instance.database;
    final batch = db.batch();
    for (final c in contacts) {
      batch.insert(_table, c.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<TransportContact>> getAll({String? area, String? type}) async {
    String? where;
    List<dynamic>? args;
    if (area != null && type != null) {
      where = 'area LIKE ? AND type = ?';
      args = ['%$area%', type];
    } else if (area != null) {
      where = 'area LIKE ?';
      args = ['%$area%'];
    } else if (type != null) {
      where = 'type = ?';
      args = [type];
    }
    final rows = await DatabaseService.instance.query(
      _table,
      where: where,
      whereArgs: args,
      orderBy: 'is_24x7 DESC, name ASC',
    );
    return rows.map(TransportContact.fromMap).toList();
  }

  Future<int> count() async {
    final result = await DatabaseService.instance.rawQuery(
      'SELECT COUNT(*) as count FROM $_table',
    );
    return (result.first['count'] as int?) ?? 0;
  }

  Future<void> deleteAll() async {
    final db = await DatabaseService.instance.database;
    await db.delete(_table);
  }
}
