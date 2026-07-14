/// Application-wide string constants.
/// Phase 12 will replace these with ARB-based i18n lookups.
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'ArogyaSathi';
  static const String appTagline = 'Your Health, Always Within Reach';

  // Navigation labels
  static const String navHome = 'Home';
  static const String navSymptomChecker = 'Symptoms';
  static const String navFirstAid = 'First Aid';
  static const String navHospitals = 'Hospitals';
  static const String navHealthCard = 'Health Card';

  // Home screen
  static const String homeGreeting = 'Namaste 🙏';
  static const String homeSubtitle = 'How can we help you today?';
  static const String homeSosLabel = 'SOS Emergency';
  static const String homeSosSubLabel = 'Tap for emergency help';

  // Quick actions
  static const String qaCheckSymptoms = 'Check Symptoms';
  static const String qaFirstAid = 'First Aid Guide';
  static const String qaFindHospital = 'Find Hospital';
  static const String qaTransport = 'Get Transport';
  static const String qaHealthCard = 'Health Card';
  static const String qaScanPrescription = 'Scan Prescription';

  // First Aid
  static const String firstAidTitle = 'First Aid Guide';
  static const String firstAidSearchHint = 'Search conditions (e.g., snake bite)…';
  static const String firstAidEmptyState = 'No results found. Try a different keyword.';

  // Hospitals
  static const String hospitalsTitle = 'Nearby Hospitals & PHCs';
  static const String hospitalsLocationRequired = 'Enable location to find nearby hospitals';

  // Health Card
  static const String healthCardTitle = 'My Health Card';
  static const String healthCardLocked = 'Secured with PIN / Biometric';
  static const String healthCardUnlock = 'Unlock Health Card';

  // Symptom Checker
  static const String symptomCheckerTitle = 'Symptom Checker';
  static const String symptomCheckerSubtitle = 'Describe your symptoms to get guidance';
  static const String symptomCheckerDisclaimer =
      '⚠️  This is not a medical diagnosis. Always consult a doctor for serious conditions.';

  // Offline badge
  static const String offlineMode = '● Offline Mode';

  // Common
  static const String loading = 'Loading…';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String callNow = 'Call Now';
  static const String getDirections = 'Get Directions';
  static const String learnMore = 'Learn More';
  static const String comingSoon = 'Coming Soon';
  static const String phaseComingSoon = 'This feature is coming in a future phase.';
}
