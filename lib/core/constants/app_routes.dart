/// Application route path constants.
/// All navigation uses these constants — never hardcoded strings.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String symptomChecker = '/symptom-checker';
  static const String firstAid = '/first-aid';
  static const String firstAidDetail = '/first-aid/:topicId';
  static const String hospitals = '/hospitals';
  static const String healthCard = '/health-card';
  static const String transport = '/transport';
  static const String settings = '/settings';
}
