/// AI / NLP service stub.
/// Phase 4: Integrate TensorFlow Lite intent classification model.
class AiService {
  AiService._();
  static final AiService instance = AiService._();

  bool _isModelLoaded = false;
  bool get isModelLoaded => _isModelLoaded;

  Future<void> loadModel() async {
    // TODO Phase 4: load quantized TFLite model from assets
    _isModelLoaded = false;
  }

  /// Extract symptom tags from free-text input.
  /// Returns structured symptom list for Phase 3 rule engine.
  Future<List<String>> extractSymptoms(String userText) async {
    // TODO Phase 4: run inference on loaded model
    // Fallback: return empty list → triggers manual symptom selection UI
    return [];
  }

  Future<void> dispose() async {
    // TODO Phase 4: release model resources
    _isModelLoaded = false;
  }
}
