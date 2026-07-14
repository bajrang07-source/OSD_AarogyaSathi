/// Severity levels used across the triage engine.
enum TriageSeverity { low, moderate, high, critical }

extension TriageSeverityX on TriageSeverity {
  String get label {
    switch (this) {
      case TriageSeverity.critical:
        return 'Critical';
      case TriageSeverity.high:
        return 'High';
      case TriageSeverity.moderate:
        return 'Moderate';
      case TriageSeverity.low:
        return 'Low';
    }
  }

  /// Recommended action headline per severity.
  String get action {
    switch (this) {
      case TriageSeverity.critical:
        return 'Call 108 immediately & go to the nearest emergency hospital.';
      case TriageSeverity.high:
        return 'Seek medical help within the next 1–2 hours.';
      case TriageSeverity.moderate:
        return 'Visit a doctor today or go to a PHC.';
      case TriageSeverity.low:
        return 'Rest and home care is likely sufficient. Monitor closely.';
    }
  }
}

/// A structured output from the Phase 3 rule-based triage engine.
class TriageResult {
  /// The assessed severity level.
  final TriageSeverity severity;

  /// Plain-language explanation of *why* this severity was assigned.
  final String reasoning;

  /// Immediate action the user should take.
  final String immediateAction;

  /// Symptom tags that triggered this result.
  final List<String> matchedSymptoms;

  /// ID of a related First Aid topic (if any).
  final int? relatedFirstAidTopicId;

  /// Name of the related First Aid condition.
  final String? relatedFirstAidCondition;

  /// Timestamp of this triage session.
  final DateTime timestamp;

  const TriageResult({
    required this.severity,
    required this.reasoning,
    required this.immediateAction,
    required this.matchedSymptoms,
    this.relatedFirstAidTopicId,
    this.relatedFirstAidCondition,
    required this.timestamp,
  });

  /// Serialise to a map for SQLite storage (triage_logs table).
  Map<String, dynamic> toLogMap() {
    return {
      'symptoms': matchedSymptoms.join(', '),
      'severity': severity.label,
      'reasoning': reasoning,
      'action_taken': immediateAction,
      'created_at': timestamp.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
