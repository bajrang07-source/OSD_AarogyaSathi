import 'dart:convert';

/// Data model for a first-aid topic stored in SQLite.
class FirstAidTopic {
  final int? id;
  final String condition;
  final List<String> steps;
  final List<String> warnings;
  final List<String> severityTags;
  final String? searchKeywords;
  final int? createdAt;

  const FirstAidTopic({
    this.id,
    required this.condition,
    required this.steps,
    this.warnings = const [],
    this.severityTags = const [],
    this.searchKeywords,
    this.createdAt,
  });

  /// Primary severity level derived from tags.
  String get severity {
    if (severityTags.any((t) => t.toLowerCase() == 'critical')) return 'Critical';
    if (severityTags.any((t) => t.toLowerCase() == 'high')) return 'High';
    if (severityTags.any((t) => t.toLowerCase() == 'moderate')) return 'Moderate';
    return 'Low';
  }

  factory FirstAidTopic.fromMap(Map<String, dynamic> map) {
    return FirstAidTopic(
      id: map['id'] as int?,
      condition: map['condition'] as String,
      steps: map['steps'] != null
          ? List<String>.from(jsonDecode(map['steps'] as String))
          : [],
      warnings: map['warnings'] != null
          ? List<String>.from(jsonDecode(map['warnings'] as String))
          : [],
      severityTags: map['severity_tags'] != null
          ? List<String>.from(jsonDecode(map['severity_tags'] as String))
          : [],
      searchKeywords: map['search_keywords'] as String?,
      createdAt: map['created_at'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'condition': condition,
      'steps': jsonEncode(steps),
      'warnings': jsonEncode(warnings),
      'severity_tags': jsonEncode(severityTags),
      'search_keywords': searchKeywords,
    };
  }

  /// Returns true if this topic matches the given search query.
  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return condition.toLowerCase().contains(q) ||
        (searchKeywords?.toLowerCase().contains(q) ?? false) ||
        steps.any((s) => s.toLowerCase().contains(q)) ||
        severityTags.any((t) => t.toLowerCase().contains(q));
  }

  @override
  String toString() => 'FirstAidTopic($id, $condition)';
}
