import '../models/first_aid_topic_model.dart';
import '../../services/db/database_service.dart';

/// Repository for first_aid_topics table CRUD and queries.
class FirstAidRepository {
  FirstAidRepository._();
  static final FirstAidRepository instance = FirstAidRepository._();

  static const String _table = DatabaseService.tableFirstAidTopics;
  static const String _favTable = DatabaseService.tableFavorites;

  /// Insert a topic. Returns new row id.
  Future<int> insert(FirstAidTopic topic) async {
    return DatabaseService.instance.insert(_table, topic.toMap());
  }

  /// Batch insert topics.
  Future<void> insertAll(List<FirstAidTopic> topics) async {
    final db = await DatabaseService.instance.database;
    final batch = db.batch();
    for (final t in topics) {
      batch.insert(_table, t.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Fetch all topics ordered by condition name.
  Future<List<FirstAidTopic>> getAll() async {
    final rows = await DatabaseService.instance.query(
      _table,
      orderBy: 'condition ASC',
    );
    return rows.map(FirstAidTopic.fromMap).toList();
  }

  /// Full-text search across condition, keywords.
  Future<List<FirstAidTopic>> search(String query) async {
    if (query.isEmpty) return getAll();
    final like = '%$query%';
    final rows = await DatabaseService.instance.rawQuery(
      '''SELECT * FROM $_table
         WHERE condition LIKE ?
            OR search_keywords LIKE ?
            OR steps LIKE ?
         ORDER BY condition ASC''',
      [like, like, like],
    );
    return rows.map(FirstAidTopic.fromMap).toList();
  }

  /// Get topic by id.
  Future<FirstAidTopic?> getById(int id) async {
    final rows = await DatabaseService.instance.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return FirstAidTopic.fromMap(rows.first);
  }

  /// Get topics by severity tag (case-insensitive via LIKE).
  Future<List<FirstAidTopic>> getBySeverity(String severity) async {
    final like = '%$severity%';
    final rows = await DatabaseService.instance.rawQuery(
      'SELECT * FROM $_table WHERE severity_tags LIKE ? ORDER BY condition ASC',
      [like],
    );
    return rows.map(FirstAidTopic.fromMap).toList();
  }

  // ── Favourites ──────────────────────────────────────────────────────────────

  /// Toggle favourite for a topic. Returns true if now favourite.
  Future<bool> toggleFavourite(int topicId) async {
    final rows = await DatabaseService.instance.query(
      _favTable,
      where: 'item_type = ? AND item_id = ?',
      whereArgs: ['first_aid', topicId],
      limit: 1,
    );
    if (rows.isEmpty) {
      await DatabaseService.instance.insert(_favTable, {
        'item_type': 'first_aid',
        'item_id': topicId,
        'saved_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      });
      return true;
    } else {
      await DatabaseService.instance.delete(
        _favTable,
        where: 'item_type = ? AND item_id = ?',
        whereArgs: ['first_aid', topicId],
      );
      return false;
    }
  }

  /// Check if a topic is favourited.
  Future<bool> isFavourite(int topicId) async {
    final rows = await DatabaseService.instance.query(
      _favTable,
      where: 'item_type = ? AND item_id = ?',
      whereArgs: ['first_aid', topicId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  /// Get all favourited topics.
  Future<List<FirstAidTopic>> getFavourites() async {
    final rows = await DatabaseService.instance.rawQuery(
      '''SELECT fa.* FROM $_table fa
         INNER JOIN $_favTable fav ON fav.item_id = fa.id
         WHERE fav.item_type = 'first_aid'
         ORDER BY fav.saved_at DESC''',
    );
    return rows.map(FirstAidTopic.fromMap).toList();
  }

  /// Count total topics.
  Future<int> count() async {
    final result = await DatabaseService.instance.rawQuery(
      'SELECT COUNT(*) as count FROM $_table',
    );
    return (result.first['count'] as int?) ?? 0;
  }

  /// Delete all topics (before re-seeding).
  Future<void> deleteAll() async {
    final db = await DatabaseService.instance.database;
    await db.delete(_table);
  }
}
