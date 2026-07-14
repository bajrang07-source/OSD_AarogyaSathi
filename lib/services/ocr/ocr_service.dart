/// OCR service stub.
/// Phase 9: Integrate Tesseract / ML Kit on-device text recognition.
class OcrService {
  OcrService._();
  static final OcrService instance = OcrService._();

  Future<String> recognizeText(String imagePath) async {
    // TODO Phase 9: run on-device OCR
    return '';
  }

  Future<Map<String, String>> parsePrescription(String rawText) async {
    // TODO Phase 9: regex/heuristic parser for Indian prescription formats
    return {};
  }
}
