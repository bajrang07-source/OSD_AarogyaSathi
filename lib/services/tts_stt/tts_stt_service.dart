import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

/// Text-to-speech and speech-to-text service.
/// Phase 4: Integrates online/offline STT (speech_to_text).
class TtsSttService {
  TtsSttService._();
  static final TtsSttService instance = TtsSttService._();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;
  String _language = 'en-IN';

  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;
  String get language => _language;

  void setLanguage(String lang) => _language = lang;

  /// Initializes the STT engine and requests mic permission.
  Future<bool> initialize() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      debugPrint('[TtsSttService] Microphone permission denied.');
      return false;
    }
    
    _isAvailable = await _speech.initialize(
      onStatus: (status) => debugPrint('[TtsSttService] onStatus: $status'),
      onError: (error) => debugPrint('[TtsSttService] onError: $error'),
    );
    return _isAvailable;
  }

  Future<void> speak(String text) async {
    // TODO Phase 7: on-device TTS
  }

  Future<void> stopSpeaking() async {
    // TODO Phase 7
  }

  /// Listens and returns the final transcribed text.
  Future<String?> listenOnce({void Function(String)? onPartialResult}) async {
    if (!_isAvailable) {
      final initialized = await initialize();
      if (!initialized) return null;
    }

    if (_isListening) return null;
    
    _isListening = true;
    String finalWords = '';

    await _speech.listen(
      onResult: (result) {
        if (onPartialResult != null) {
          onPartialResult(result.recognizedWords);
        }
        if (result.finalResult) {
          finalWords = result.recognizedWords;
        }
      },
      listenOptions: stt.SpeechListenOptions(
        localeId: _language,
        cancelOnError: true,
        partialResults: true,
        listenMode: stt.ListenMode.dictation,
      ),
    );

    // Give it some time to listen before stopping automatically, or wait until the user stops.
    // The plugin automatically stops on silence, but we wait for it to stop.
    while (_speech.isListening) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    _isListening = false;
    return finalWords.isNotEmpty ? finalWords : null;
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  Future<void> dispose() async {
    await stopListening();
    await stopSpeaking();
  }
}
