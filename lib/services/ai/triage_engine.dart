import '../../data/models/triage_result_model.dart';

// â”€â”€ Symptom constants â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// These are the canonical symptom tags the rule engine understands.
// Phase 4 NLP maps free-text to these same tags.

class Symptoms {
  Symptoms._();

  // Cardiovascular
  static const String chestPain = 'chest_pain';
  static const String palpitations = 'palpitations';
  static const String irregularHeartbeat = 'irregular_heartbeat';

  // Respiratory
  static const String breathingDifficulty = 'breathing_difficulty';
  static const String wheezing = 'wheezing';
  static const String rapidBreathing = 'rapid_breathing';

  // Neurological
  static const String unconsciousness = 'unconsciousness';
  static const String seizure = 'seizure';
  static const String confusionDisorientation = 'confusion_disorientation';
  static const String severeHeadache = 'severe_headache';
  static const String weaknessNumbness = 'weakness_numbness';
  static const String facialDropping = 'facial_drooping';
  static const String speechDifficulty = 'speech_difficulty';
  static const String dizziness = 'dizziness';

  // GI
  static const String severeAbdominalPain = 'severe_abdominal_pain';
  static const String vomiting = 'vomiting';
  static const String diarrhea = 'diarrhea';
  static const String bloodInStool = 'blood_in_stool';

  // Trauma / External
  static const String snakeBite = 'snake_bite';
  static const String animalBite = 'animal_bite';
  static const String severeBleed = 'severe_bleeding';
  static const String burn = 'burn';
  static const String fracture = 'fracture';
  static const String headInjury = 'head_injury';
  static const String eyeInjury = 'eye_injury';

  // Fever / Infection
  static const String highFever = 'high_fever';        // â‰¥103Â°F / 39.4Â°C
  static const String moderateFever = 'moderate_fever'; // 100â€“103Â°F
  static const String chills = 'chills';
  static const String rash = 'rash';
  static const String stiffNeck = 'stiff_neck';

  // Paediatric
  static const String infantNotFeeding = 'infant_not_feeding';
  static const String infantHighFever = 'infant_high_fever';

  // Other
  static const String choking = 'choking';
  static const String allergicReaction = 'allergic_reaction';
  static const String swelling = 'swelling';
  static const String sweating = 'sweating';
  static const String fainting = 'fainting';
  static const String extremeFatigue = 'extreme_fatigue';
  static const String dehydration = 'dehydration';
  static const String heatExposure = 'heat_exposure';
  static const String coldExposure = 'cold_exposure';
  static const String poison = 'poison_ingestion';

  /// All known symptom tags with their user-facing labels.
  static const Map<String, String> labels = {
    chestPain: 'Chest Pain',
    palpitations: 'Heart Palpitations',
    irregularHeartbeat: 'Irregular Heartbeat',
    breathingDifficulty: 'Difficulty Breathing',
    wheezing: 'Wheezing',
    rapidBreathing: 'Rapid Breathing',
    unconsciousness: 'Unconscious / Unresponsive',
    seizure: 'Seizure / Convulsions',
    confusionDisorientation: 'Confusion / Disorientation',
    severeHeadache: 'Severe Headache',
    weaknessNumbness: 'Weakness / Numbness',
    facialDropping: 'Facial Drooping (one side)',
    speechDifficulty: 'Difficulty Speaking',
    dizziness: 'Dizziness / Lightheadedness',
    severeAbdominalPain: 'Severe Abdominal Pain',
    vomiting: 'Vomiting',
    diarrhea: 'Diarrhoea',
    bloodInStool: 'Blood in Stool',
    snakeBite: 'Snake Bite',
    animalBite: 'Animal Bite',
    severeBleed: 'Severe Bleeding',
    burn: 'Burns',
    fracture: 'Fracture / Broken Bone',
    headInjury: 'Head Injury',
    eyeInjury: 'Eye Injury',
    highFever: 'High Fever (â‰¥103Â°F / 39.4Â°C)',
    moderateFever: 'Moderate Fever (100â€“103Â°F)',
    chills: 'Chills / Shivering',
    rash: 'Skin Rash',
    stiffNeck: 'Stiff Neck',
    infantNotFeeding: 'Infant Refusing to Feed',
    infantHighFever: 'Infant with High Fever',
    choking: 'Choking',
    allergicReaction: 'Allergic Reaction / Swollen Face',
    swelling: 'Swelling',
    sweating: 'Profuse Sweating',
    fainting: 'Fainting / Collapse',
    extremeFatigue: 'Extreme Fatigue',
    dehydration: 'Signs of Dehydration',
    heatExposure: 'Prolonged Heat / Sun Exposure',
    coldExposure: 'Cold Exposure / Hypothermia',
    poison: 'Possible Poison Ingestion',
  };

  /// Group labels for the selection UI.
  static const Map<String, List<String>> groups = {
    '🫀 Heart & Chest': [chestPain, palpitations, irregularHeartbeat, sweating],
    '🫁 Breathing': [breathingDifficulty, wheezing, rapidBreathing, choking],
    '🧠 Neurological': [unconsciousness, seizure, confusionDisorientation, severeHeadache, weaknessNumbness, facialDropping, speechDifficulty, dizziness],
    '🤕 Trauma': [snakeBite, animalBite, severeBleed, burn, fracture, headInjury, eyeInjury],
    '🤒 Fever & Infection': [highFever, moderateFever, chills, rash, stiffNeck],
    '🤢 Stomach & GI': [severeAbdominalPain, vomiting, diarrhea, bloodInStool],
    '🌡️ Other': [fainting, allergicReaction, swelling, extremeFatigue, dehydration, heatExposure, coldExposure, poison, infantNotFeeding, infantHighFever],
  };
}

// â”€â”€ Rule engine â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

/// Pure, stateless rule-based triage engine.
///
/// Takes a set of symptom tags â†’ returns a [TriageResult] with
/// severity, reasoning (human-readable), and recommended action.
///
/// Rules are intentionally conservative (err towards higher severity).
/// The engine never produces freeform diagnosis text â€” only maps
/// symptom combinations to the four severity tiers.
class TriageEngine {
  TriageEngine._();
  static final TriageEngine instance = TriageEngine._();

  TriageResult evaluate(List<String> symptoms) {
    final s = symptoms.toSet();
    final now = DateTime.now();

    // â”€â”€ CRITICAL rules (must be checked first) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    if (s.contains(Symptoms.unconsciousness)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'Unconsciousness or unresponsiveness is a life-threatening emergency. '
            'The patient may have stopped breathing.',
        immediateAction: Symptoms.chestPain.contains(Symptoms.chestPain)
            ? 'Begin CPR if not breathing. Call 108 immediately.'
            : 'Ensure airway is open. Begin CPR if not breathing. Call 108.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 7,
        relatedFirstAidCondition: 'Fainting (Unconsciousness)',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.seizure)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'A seizure or convulsion requires immediate medical evaluation. '
            'It may indicate a neurological emergency, high fever (febrile seizure), or other serious condition.',
        immediateAction: 'Protect from injury. Do NOT restrain. Call 108 now.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.choking)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'Choking is immediately life-threatening â€” the airway is blocked.',
        immediateAction:
            'Give 5 back blows, then 5 abdominal thrusts (Heimlich). Call 112 now.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 8,
        relatedFirstAidCondition: 'Choking',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.snakeBite)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'A snake bite can inject life-threatening venom. Symptoms may be delayed â€” '
            'do not wait for them to appear before seeking help.',
        immediateAction:
            'Keep calm & still. Go to emergency hospital NOW for anti-venom.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 1,
        relatedFirstAidCondition: 'Snake Bite',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.severeBleed)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'Severe uncontrolled bleeding can lead to haemorrhagic shock within minutes.',
        immediateAction:
            'Apply firm continuous pressure. Call 108. Do NOT remove cloth.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 7,
        relatedFirstAidCondition: 'Severe Bleeding',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.breathingDifficulty) &&
        (s.contains(Symptoms.chestPain) ||
            s.contains(Symptoms.sweating) ||
            s.contains(Symptoms.palpitations))) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'Breathing difficulty combined with chest pain or sweating is a classic presentation '
            'of a cardiac emergency (heart attack / acute coronary event).',
        immediateAction: 'Call 108 immediately. Loosen tight clothing. Do not exert.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    // Stroke triad: facial drooping + arm weakness + speech difficulty
    if ((s.contains(Symptoms.facialDropping) ||
            s.contains(Symptoms.speechDifficulty) ||
            s.contains(Symptoms.weaknessNumbness)) &&
        s.length >= 2) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'The combination of facial drooping, arm weakness, or speech difficulty '
            'strongly suggests a stroke (FAST: Face, Arms, Speech, Time). '
            'Every minute of delay causes brain damage.',
        immediateAction: 'Call 108 NOW. Note the time symptoms started.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.allergicReaction) &&
        s.contains(Symptoms.breathingDifficulty)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'Allergic reaction with breathing difficulty indicates anaphylaxis â€” '
            'a severe, potentially fatal allergic response.',
        immediateAction: 'Give epinephrine if available. Call 108 immediately.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.poison)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning: 'Suspected poison ingestion requires immediate emergency care.',
        immediateAction: 'Do NOT induce vomiting. Call 108 / Poison Control now.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.heatExposure) && s.contains(Symptoms.unconsciousness)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning: 'Heat stroke with unconsciousness is life-threatening.',
        immediateAction: 'Move to shade, cool with water, call 108 immediately.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 5,
        relatedFirstAidCondition: 'Heat Stroke',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.headInjury) && s.contains(Symptoms.unconsciousness)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning: 'Head injury with loss of consciousness may indicate traumatic brain injury.',
        immediateAction:
            'Do NOT move the patient unless in danger. Keep still, call 108.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    // â”€â”€ HIGH rules â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    if (s.contains(Symptoms.chestPain)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning:
            'Chest pain must always be taken seriously. It could indicate a cardiac issue, '
            'pulmonary embolism, or other serious condition.',
        immediateAction:
            'Seek emergency care within 1 hour. Call 108 if pain worsens, spreads, or breathing becomes difficult.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.breathingDifficulty)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning:
            'Breathing difficulty can be caused by asthma, pneumonia, heart failure, or other serious conditions.',
        immediateAction: 'Seek emergency care within 1 hour. Sit upright. Do not lie flat.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.burn)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning: 'Burns require prompt assessment to prevent infection and complications.',
        immediateAction:
            'Cool under running water 10â€“20 min. Go to hospital for burns larger than victim\'s palm.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 2,
        relatedFirstAidCondition: 'Burns',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.fracture)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning: 'A suspected fracture needs X-ray and professional immobilisation.',
        immediateAction:
            'Immobilise the limb. Do NOT attempt to straighten. Go to hospital.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 4,
        relatedFirstAidCondition: 'Fracture (Broken Bone)',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.highFever) && s.contains(Symptoms.stiffNeck)) {
      return TriageResult(
        severity: TriageSeverity.critical,
        reasoning:
            'High fever with stiff neck is a classic presentation of meningitis â€” a medical emergency.',
        immediateAction: 'Go to emergency hospital IMMEDIATELY. Call 108.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.highFever)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning:
            'A temperature of â‰¥103Â°F (39.4Â°C) requires prompt medical evaluation, '
            'especially to rule out malaria, dengue, or typhoid in rural Maharashtra.',
        immediateAction:
            'Go to a PHC or hospital today. Give paracetamol to reduce fever. Hydrate well.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.infantHighFever) ||
        s.contains(Symptoms.infantNotFeeding)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning: 'Any fever or feeding refusal in a young infant is serious and needs same-day evaluation.',
        immediateAction: 'Take the infant to a hospital or PHC today without delay.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.heatExposure) && s.contains(Symptoms.confusionDisorientation)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning: 'Heat exposure with confusion may indicate heat stroke.',
        immediateAction: 'Move to shade, cool body, go to hospital urgently.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 5,
        relatedFirstAidCondition: 'Heat Stroke',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.severeAbdominalPain)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning:
            'Severe abdominal pain may indicate appendicitis, obstruction, or other surgical emergency.',
        immediateAction: 'Go to a hospital with surgery capability today.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.bloodInStool)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning: 'Blood in stool may indicate GI bleeding and needs medical evaluation.',
        immediateAction: 'Visit a hospital today.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.headInjury) && s.contains(Symptoms.vomiting)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning:
            'Head injury with vomiting may indicate concussion or raised intracranial pressure.',
        immediateAction: 'Go to hospital today. Monitor closely for worsening.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    // â”€â”€ MODERATE rules â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    if (s.contains(Symptoms.moderateFever)) {
      final extras = s.intersection({
        Symptoms.chills, Symptoms.rash, Symptoms.severeHeadache
      });
      return TriageResult(
        severity: extras.isNotEmpty
            ? TriageSeverity.high
            : TriageSeverity.moderate,
        reasoning: extras.isNotEmpty
            ? 'Fever with additional symptoms (chills, rash, severe headache) may indicate dengue or malaria.'
            : 'A moderate fever should be monitored. Common causes include viral infections.',
        immediateAction: extras.isNotEmpty
            ? 'Visit a PHC or hospital today. Get a blood test for malaria / dengue.'
            : 'Paracetamol for fever, rest, fluids. Visit PHC if not improving in 2 days.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.fainting) || s.contains(Symptoms.dizziness)) {
      return TriageResult(
        severity: TriageSeverity.moderate,
        reasoning: 'Fainting or persistent dizziness needs evaluation for dehydration, low blood pressure, or other causes.',
        immediateAction: 'Rest in a cool area. Hydrate. Visit a PHC today if recurring.',
        matchedSymptoms: symptoms,
        relatedFirstAidTopicId: 6,
        relatedFirstAidCondition: 'Fainting (Unconsciousness)',
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.dehydration)) {
      return TriageResult(
        severity: TriageSeverity.moderate,
        reasoning: 'Dehydration, especially in hot weather or with diarrhoea/vomiting, can become serious.',
        immediateAction:
            'Give ORS (oral rehydration salts). Drink fluids. Go to PHC if unable to keep fluids down.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.vomiting) && s.contains(Symptoms.diarrhea)) {
      return TriageResult(
        severity: TriageSeverity.moderate,
        reasoning:
            'Vomiting with diarrhoea can cause dangerous dehydration, especially in children.',
        immediateAction: 'Give ORS frequently. Monitor for dehydration signs. Visit PHC if not improving.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.rash) && s.contains(Symptoms.highFever)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning: 'Rash with high fever may indicate dengue, measles, or other serious infections.',
        immediateAction: 'Go to a hospital or PHC today for evaluation.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    if (s.contains(Symptoms.animalBite)) {
      return TriageResult(
        severity: TriageSeverity.high,
        reasoning:
            'Animal bites carry risk of rabies, especially from dogs, cats, monkeys, and bats. '
            'Rabies is 100% fatal once symptoms appear â€” vaccination must start within 24 hours.',
        immediateAction:
            'Wash wound with soap/water for 15 min. Go to hospital immediately for rabies vaccination.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    // â”€â”€ LOW rules (catch-all) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    if (symptoms.isEmpty) {
      return TriageResult(
        severity: TriageSeverity.low,
        reasoning: 'No symptoms selected. Please describe what you are experiencing.',
        immediateAction: 'Select your symptoms above or describe them in the text box.',
        matchedSymptoms: symptoms,
        timestamp: now,
      );
    }

    // Generic low-severity result
    return TriageResult(
      severity: TriageSeverity.low,
      reasoning:
          'Based on the symptoms selected, this appears to be a low-severity condition. '
          'However, all symptoms should be monitored and a doctor should be consulted if they worsen.',
      immediateAction:
          'Rest at home. Monitor symptoms. Visit a PHC if no improvement within 48 hours.',
      matchedSymptoms: symptoms,
      timestamp: now,
    );
  }
}
