/// Text-to-speech and speech-to-text service stub.
/// Phase 7: Integrate offline STT (Whisper.cpp) and TTS.
class TtsSttService {
  TtsSttService._();
  static final TtsSttService instance = TtsSttService._();

  String _language = 'en-IN';
  String get language => _language;

  void setLanguage(String lang) => _language = lang;

  Future<void> speak(String text) async {
    // TODO Phase 7: on-device TTS
  }

  Future<void> stopSpeaking() async {
    // TODO Phase 7
  }

  Future<String?> listenOnce() async {
    // TODO Phase 7: on-device STT, returns transcription
    return null;
  }

  Future<void> dispose() async {
    // TODO Phase 7
  }
}
