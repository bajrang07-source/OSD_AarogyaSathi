import 'package:flutter/foundation.dart';
import 'triage_engine.dart'; // To get the symptom tags

/// AI / NLP service.
/// Phase 4: Keyword matching fallback (TFLite intent classification deferred).
class AiService {
  AiService._();
  static final AiService instance = AiService._();

  bool _isModelLoaded = false;
  bool get isModelLoaded => _isModelLoaded;

  Future<void> loadModel() async {
    // TODO Phase 4: load quantized TFLite model from assets
    // Since no model is provided, we simulate it being loaded.
    _isModelLoaded = true;
    debugPrint('[AiService] Using keyword fallback model.');
  }

  /// Extract symptom tags from free-text input.
  /// Returns structured symptom list for Phase 3 rule engine.
  Future<List<String>> extractSymptoms(String userText) async {
    // Basic fallback: keyword matching against canonical tags.
    final text = userText.toLowerCase();
    final matched = <String>{};

    for (final entry in Symptoms.labels.entries) {
      final tag = entry.key;
      final label = entry.value.toLowerCase();
      
      // Match the exact label or the tag itself
      if (text.contains(label) || text.contains(tag.replaceAll('_', ' '))) {
        matched.add(tag);
      }
    }

    // Some custom mappings
    if (text.contains('puking') || text.contains('throw up')) matched.add(Symptoms.vomiting);
    if (text.contains('can\'t breathe')) matched.add(Symptoms.breathingDifficulty);
    if (text.contains('hot')) matched.add(Symptoms.highFever);
    if (text.contains('hurt') && text.contains('chest')) matched.add(Symptoms.chestPain);
    
    return matched.toList();
  }

  Future<void> dispose() async {
    _isModelLoaded = false;
  }
}
