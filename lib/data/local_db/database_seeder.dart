import 'package:flutter/foundation.dart';
import '../models/hospital_model.dart';
import '../models/first_aid_topic_model.dart';
import '../models/transport_contact_model.dart';
import '../repositories/hospital_repository.dart';
import '../repositories/first_aid_repository.dart';
import '../repositories/transport_repository.dart';

/// Seeds the local SQLite database with realistic sample data
/// for Palghar District, Maharashtra.
///
/// Idempotent — checks if data already exists before seeding.
class DatabaseSeeder {
  DatabaseSeeder._();
  static final DatabaseSeeder instance = DatabaseSeeder._();

  Future<void> seedAll({bool force = false}) async {
    debugPrint('[DatabaseSeeder] Checking if seeding needed…');

    final hospitalCount = await HospitalRepository.instance.count();
    final firstAidCount = await FirstAidRepository.instance.count();
    final transportCount = await TransportRepository.instance.count();

    if (!force && hospitalCount > 0 && firstAidCount > 0 && transportCount > 0) {
      debugPrint('[DatabaseSeeder] Data already seeded. Skipping.');
      return;
    }

    debugPrint('[DatabaseSeeder] Seeding database…');

    if (force || hospitalCount == 0) await _seedHospitals();
    if (force || firstAidCount == 0) await _seedFirstAid();
    if (force || transportCount == 0) await _seedTransport();

    debugPrint('[DatabaseSeeder] Seeding complete.');
  }

  // ── Hospitals (20 real PHCs / hospitals in Palghar District) ──────────────

  Future<void> _seedHospitals() async {
    debugPrint('[DatabaseSeeder] Seeding hospitals…');
    await HospitalRepository.instance.deleteAll();
    await HospitalRepository.instance.insertAll(_hospitals);
    debugPrint('[DatabaseSeeder] ${_hospitals.length} hospitals seeded.');
  }

  static final List<Hospital> _hospitals = [
    Hospital(
      name: 'Palghar District General Hospital',
      type: 'District Hospital',
      lat: 19.6967,
      lng: 72.7659,
      address: 'Dr. Babasaheb Ambedkar Road, Palghar',
      phone: '02525-252222',
      district: 'Palghar',
      services: ['Emergency', 'ICU', 'Surgery', 'Maternity', 'Blood Bank', 'X-Ray', 'Lab', 'Paediatrics'],
      emergencyCapable: true,
      beds: 200,
      lastSynced: _now,
    ),
    Hospital(
      name: 'Sub-District Hospital Vasai',
      type: 'Sub-District Hospital',
      lat: 19.3641,
      lng: 72.8069,
      address: 'Station Road, Vasai West',
      phone: '0250-2337000',
      district: 'Palghar',
      services: ['Emergency', 'Surgery', 'Maternity', 'Blood Bank', 'X-Ray'],
      emergencyCapable: true,
      beds: 100,
      lastSynced: _now,
    ),
    Hospital(
      name: 'Sub-District Hospital Dahanu',
      type: 'Sub-District Hospital',
      lat: 19.9695,
      lng: 72.7178,
      address: 'Dahanu Road, Dahanu',
      phone: '02528-222211',
      district: 'Palghar',
      services: ['Emergency', 'Surgery', 'Maternity', 'Lab', 'X-Ray'],
      emergencyCapable: true,
      beds: 80,
      lastSynced: _now,
    ),
    Hospital(
      name: 'Rural Hospital Vikramgad',
      type: 'Rural Hospital',
      lat: 19.8347,
      lng: 73.0617,
      address: 'Vikramgad, Palghar District',
      phone: '02520-244500',
      district: 'Palghar',
      services: ['Emergency', 'Surgery', 'Maternity', 'OPD'],
      emergencyCapable: true,
      beds: 50,
      lastSynced: _now,
    ),
    Hospital(
      name: 'Rural Hospital Jawhar',
      type: 'Rural Hospital',
      lat: 19.9058,
      lng: 73.2233,
      address: 'Jawhar, Palghar District',
      phone: '02520-240400',
      district: 'Palghar',
      services: ['Emergency', 'Maternity', 'OPD', 'Lab'],
      emergencyCapable: true,
      beds: 50,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Kasa',
      type: 'Primary Health Centre',
      lat: 19.8123,
      lng: 73.1456,
      address: 'Kasa, Dahanu Taluka',
      phone: '02528-271234',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Maternity', 'Family Planning'],
      emergencyCapable: false,
      beds: 10,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Zai',
      type: 'Primary Health Centre',
      lat: 19.7456,
      lng: 72.9234,
      address: 'Zai Village, Mokhada Taluka',
      phone: '02527-221100',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Antenatal Care', 'Family Planning'],
      emergencyCapable: false,
      beds: 6,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Manor',
      type: 'Primary Health Centre',
      lat: 19.7789,
      lng: 72.9034,
      address: 'Manor, Palghar Taluka',
      phone: '02525-281234',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Maternity', 'Family Planning'],
      emergencyCapable: false,
      beds: 10,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Safala',
      type: 'Primary Health Centre',
      lat: 19.6234,
      lng: 72.7890,
      address: 'Safala, Palghar Taluka',
      phone: '02525-254321',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Family Planning'],
      emergencyCapable: false,
      beds: 6,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Umbargaon',
      type: 'Primary Health Centre',
      lat: 20.1678,
      lng: 72.7569,
      address: 'Umbargaon, Dahanu Taluka',
      phone: '02528-273456',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Maternity'],
      emergencyCapable: false,
      beds: 10,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Chikhale',
      type: 'Primary Health Centre',
      lat: 19.5123,
      lng: 72.8967,
      address: 'Chikhale, Vasai Taluka',
      phone: '0250-2481234',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Family Planning', 'Antenatal Care'],
      emergencyCapable: false,
      beds: 6,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Wada',
      type: 'Primary Health Centre',
      lat: 19.6589,
      lng: 73.1234,
      address: 'Wada, Palghar District',
      phone: '02526-241234',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Maternity', 'Family Planning'],
      emergencyCapable: false,
      beds: 10,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Talasari',
      type: 'Primary Health Centre',
      lat: 20.2678,
      lng: 72.8456,
      address: 'Talasari, Dahanu Taluka',
      phone: '02528-274567',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Maternity'],
      emergencyCapable: false,
      beds: 10,
      lastSynced: _now,
    ),
    Hospital(
      name: 'Jeevan Raksha Hospital',
      type: 'Private Hospital',
      lat: 19.6934,
      lng: 72.7712,
      address: 'Market Road, Palghar',
      phone: '02525-254123',
      district: 'Palghar',
      services: ['Emergency', 'Surgery', 'ICU', 'X-Ray', 'Lab', 'Orthopaedics'],
      emergencyCapable: true,
      beds: 60,
      lastSynced: _now,
    ),
    Hospital(
      name: 'Shree Sai Hospital Vasai',
      type: 'Private Hospital',
      lat: 19.3712,
      lng: 72.8123,
      address: 'SV Road, Vasai East',
      phone: '0250-2335678',
      district: 'Palghar',
      services: ['Emergency', 'Surgery', 'Maternity', 'Paediatrics', 'Lab'],
      emergencyCapable: true,
      beds: 80,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Kelwa',
      type: 'Primary Health Centre',
      lat: 19.6012,
      lng: 72.7234,
      address: 'Kelwa Beach Road, Palghar',
      phone: '02525-256789',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Family Planning'],
      emergencyCapable: false,
      beds: 6,
      lastSynced: _now,
    ),
    Hospital(
      name: 'Community Health Centre Mokhada',
      type: 'Community Health Centre',
      lat: 19.6489,
      lng: 73.1678,
      address: 'Mokhada, Palghar District',
      phone: '02527-224567',
      district: 'Palghar',
      services: ['Emergency', 'Maternity', 'OPD', 'Lab', 'X-Ray'],
      emergencyCapable: true,
      beds: 30,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Gholvad',
      type: 'Primary Health Centre',
      lat: 20.0567,
      lng: 72.7345,
      address: 'Gholvad, Dahanu Taluka',
      phone: '02528-279123',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Maternity', 'Family Planning'],
      emergencyCapable: false,
      beds: 10,
      lastSynced: _now,
    ),
    Hospital(
      name: 'Wockhardt Hospital Mira Road',
      type: 'Private Hospital',
      lat: 19.2890,
      lng: 72.8678,
      address: 'Mira Road East, Thane District',
      phone: '022-39100000',
      district: 'Thane',
      services: ['Emergency', 'ICU', 'Surgery', 'Cardiology', 'Neurology', 'Blood Bank', 'MRI'],
      emergencyCapable: true,
      beds: 200,
      lastSynced: _now,
    ),
    Hospital(
      name: 'PHC Nandgaon',
      type: 'Primary Health Centre',
      lat: 20.3123,
      lng: 72.8234,
      address: 'Nandgaon, Dahanu Taluka',
      phone: '02528-278901',
      district: 'Palghar',
      services: ['OPD', 'Vaccination', 'Maternity'],
      emergencyCapable: false,
      beds: 6,
      lastSynced: _now,
    ),
  ];

  // ── First Aid Topics ───────────────────────────────────────────────────────

  Future<void> _seedFirstAid() async {
    debugPrint('[DatabaseSeeder] Seeding first-aid topics…');
    await FirstAidRepository.instance.deleteAll();
    await FirstAidRepository.instance.insertAll(_firstAidTopics);
    debugPrint('[DatabaseSeeder] ${_firstAidTopics.length} first-aid topics seeded.');
  }

  static final List<FirstAidTopic> _firstAidTopics = [
    // 1. Snake Bite
    FirstAidTopic(
      condition: 'Snake Bite',
      steps: [
        'Stay calm — panic speeds up venom spread. Reassure the victim.',
        'Keep the bitten limb still and below heart level.',
        'Remove rings, watches, or tight clothing near the bite.',
        'Mark the edge of swelling with a pen and note the time.',
        'Do NOT apply a tourniquet, cut the wound, or suck venom.',
        'Do NOT apply ice or herbal remedies to the bite.',
        'Transport the victim to the nearest emergency hospital IMMEDIATELY.',
        'Note the snake\'s appearance (colour, markings) if safe to do so — do not try to catch it.',
      ],
      warnings: [
        '⚠️ This is a CRITICAL emergency — go to hospital even if no symptoms yet.',
        '⚠️ Anti-venom must be given by a doctor; do NOT attempt home treatment.',
        '⚠️ Symptoms may be delayed 30–60 minutes. Never wait to "see if it gets bad".',
      ],
      severityTags: ['Critical', 'emergency', 'poison'],
      searchKeywords: 'snake venom bite poison rural reptile fangs',
    ),

    // 2. Burns
    FirstAidTopic(
      condition: 'Burns',
      steps: [
        'Remove the victim from the source of heat immediately.',
        'Remove any clothing or jewellery near the burnt area (unless stuck to skin).',
        'Cool the burn under cool (not cold) running water for 10–20 minutes.',
        'Do NOT use ice, butter, toothpaste, or any oils on the burn.',
        'Cover loosely with a clean, non-fluffy material (e.g., cling film or a clean cloth).',
        'For small burns (smaller than the victim\'s palm), keep cool and covered.',
        'For large burns (face, hands, genitals, or >1% body area): go to hospital immediately.',
        'Give paracetamol or ibuprofen for pain if available and victim is conscious.',
      ],
      warnings: [
        '⚠️ Chemical burns: flush with water for at least 20 minutes. Remove contaminated clothing carefully.',
        '⚠️ Electrical burns: do NOT touch victim if still in contact with power source.',
        '⚠️ Seek emergency help for burns involving face, airway, hands, or large body surface.',
      ],
      severityTags: ['High', 'thermal', 'chemical'],
      searchKeywords: 'burn fire scald hot water flame blister skin thermal',
    ),

    // 3. Cuts & Wounds
    FirstAidTopic(
      condition: 'Cuts & Wounds',
      steps: [
        'Apply firm pressure with a clean cloth or bandage for at least 10 minutes.',
        'Do NOT remove the cloth if soaked — add more on top.',
        'Once bleeding stops, clean the wound gently with clean water.',
        'Apply antiseptic (Dettol, Savlon, or Betadine) and cover with a sterile bandage.',
        'For deep wounds: do NOT remove embedded objects; stabilise and go to hospital.',
        'Check tetanus vaccination status — update if the wound is dirty or deep.',
      ],
      warnings: [
        '⚠️ Go to hospital for: spurting blood, wounds that won\'t stop bleeding in 15 min, deep cuts, bites.',
        '⚠️ Do NOT use tourniquet except for life-threatening limb bleeding.',
        '⚠️ Signs of infection (redness, warmth, pus, fever) require medical attention.',
      ],
      severityTags: ['Low', 'wound', 'laceration'],
      searchKeywords: 'cut wound laceration bleeding scratch graze knife glass',
    ),

    // 4. Fracture / Broken Bone
    FirstAidTopic(
      condition: 'Fracture (Broken Bone)',
      steps: [
        'Keep the injured person still. Do NOT try to straighten the limb.',
        'Immobilise the fracture using a splint or by padding and bandaging it in the position found.',
        'If a splint is unavailable, use a rigid object (stick, folded newspaper) padded with cloth.',
        'Apply ice wrapped in cloth to reduce swelling (20 min on, 20 min off).',
        'Elevate the injured limb if possible without moving it further.',
        'For suspected spine fractures: do NOT move the victim at all without emergency support.',
        'Transport to hospital for X-ray and proper treatment.',
      ],
      warnings: [
        '⚠️ Open fractures (bone through skin): cover with clean cloth — do NOT push bone back.',
        '⚠️ Suspected neck or spine injury: do NOT move the person. Call emergency services.',
        '⚠️ Seek emergency care if circulation/sensation is lost below the injury.',
      ],
      severityTags: ['High', 'orthopaedic', 'trauma'],
      searchKeywords: 'fracture broken bone crack spine neck arm leg fall trauma',
    ),

    // 5. Heat Stroke
    FirstAidTopic(
      condition: 'Heat Stroke',
      steps: [
        'Move the person to a cool, shaded area immediately.',
        'Call emergency services / arrange transport to hospital NOW.',
        'Remove excess clothing.',
        'Cool the body rapidly: apply cool wet cloths to skin, especially neck, armpits, groin.',
        'Fan the person while applying cool water.',
        'If conscious and able to swallow, give cool water to sip.',
        'Do NOT give alcohol or caffeine.',
        'Place unconscious victims in the recovery position.',
      ],
      warnings: [
        '⚠️ Heat stroke is LIFE-THREATENING — body temperature above 40°C can cause organ damage.',
        '⚠️ Confusion, seizures, or loss of consciousness: this is Critical — call emergency immediately.',
        '⚠️ Do NOT give fever medication (paracetamol) — it will not help in heat stroke.',
      ],
      severityTags: ['Critical', 'heat', 'hyperthermia'],
      searchKeywords: 'heat stroke sun exhaustion temperature summer hot unconscious',
    ),

    // 6. Fainting
    FirstAidTopic(
      condition: 'Fainting (Unconsciousness)',
      steps: [
        'Catch the person gently if you can to prevent injury from falling.',
        'Lay the person flat on their back on a firm surface.',
        'Raise their legs 15–30 cm above heart level (if no suspected injury).',
        'Loosen any tight clothing around the neck and waist.',
        'Ensure fresh air — open windows or ask bystanders to step back.',
        'Check breathing — if not breathing, begin CPR.',
        'If breathing normally, they should regain consciousness within 1–2 minutes.',
        'Once conscious, keep them lying down for a few minutes before sitting up.',
      ],
      warnings: [
        '⚠️ Seek medical attention if person does not regain consciousness within 2 minutes.',
        '⚠️ Call emergency if fainted after chest pain, head injury, or difficulty breathing.',
        '⚠️ Do NOT give liquids until fully conscious and able to swallow safely.',
      ],
      severityTags: ['Moderate', 'syncope', 'collapse'],
      searchKeywords: 'faint unconscious dizzy collapse syncope blackout pass out',
    ),

    // 7. Severe Bleeding
    FirstAidTopic(
      condition: 'Severe Bleeding',
      steps: [
        'Protect yourself with gloves or extra layers of cloth if available.',
        'Apply firm, direct pressure to the wound with a clean cloth or bandage.',
        'Hold pressure continuously for at least 10–15 minutes without lifting to check.',
        'If blood soaks through, add more material on top — do NOT remove first layer.',
        'Elevate the bleeding body part above heart level if possible.',
        'For limb bleeding that cannot be controlled: apply tourniquet 5–7 cm above wound.',
        'Note tourniquet time and transport to hospital IMMEDIATELY.',
      ],
      warnings: [
        '⚠️ Bright red spurting blood = arterial bleed = CRITICAL. Apply maximum pressure and call emergency.',
        '⚠️ Do NOT remove objects embedded in wounds — stabilise and take to hospital.',
        '⚠️ A tourniquet should only be used for life-threatening limb bleeding.',
      ],
      severityTags: ['High', 'haemorrhage', 'blood'],
      searchKeywords: 'bleeding blood wound gash haemorrhage tourniquet artery vein',
    ),

    // 8. Choking
    FirstAidTopic(
      condition: 'Choking',
      steps: [
        'Ask the person: "Are you choking?" — if they cannot speak/cough/breathe, act immediately.',
        'Encourage the person to cough hard if they can.',
        'Stand behind them, lean them forward slightly.',
        'Give up to 5 firm back blows between shoulder blades with heel of your hand.',
        'Check mouth — remove any visible obstruction.',
        'If still choking: give up to 5 abdominal thrusts (Heimlich manoeuvre).',
        'Alternate 5 back blows and 5 abdominal thrusts until object is dislodged.',
        'If the person becomes unconscious: begin CPR and call emergency services.',
        'For infants: use 5 back blows + 5 chest thrusts (NOT abdominal thrusts).',
      ],
      warnings: [
        '⚠️ Choking is LIFE-THREATENING — act within seconds.',
        '⚠️ Do NOT perform abdominal thrusts on infants under 1 year.',
        '⚠️ Seek medical attention after any choking episode — internal injury is possible.',
      ],
      severityTags: ['Critical', 'airway', 'obstruction'],
      searchKeywords: 'choking airway obstruction Heimlich throat food object suffocate',
    ),
  ];

  // ── Transport Contacts ─────────────────────────────────────────────────────

  Future<void> _seedTransport() async {
    debugPrint('[DatabaseSeeder] Seeding transport contacts…');
    await TransportRepository.instance.deleteAll();
    await TransportRepository.instance.insertAll(_transportContacts);
    debugPrint('[DatabaseSeeder] ${_transportContacts.length} transport contacts seeded.');
  }

  static final List<TransportContact> _transportContacts = [
    TransportContact(
      name: 'ZILLA PARISHAD Ambulance — Palghar',
      type: 'ambulance',
      phone: '108',
      area: 'Palghar District',
      is24x7: true,
      vehicleType: 'Advanced Life Support',
      notes: 'Free government emergency ambulance. Available 24/7.',
    ),
    TransportContact(
      name: 'National Emergency Number',
      type: 'ambulance',
      phone: '112',
      area: 'All India',
      is24x7: true,
      vehicleType: 'Police/Ambulance/Fire',
      notes: 'Integrated emergency response. Dispatch ambulance + police.',
    ),
    TransportContact(
      name: 'Palghar Civil Hospital Ambulance',
      type: 'ambulance',
      phone: '02525-252222',
      area: 'Palghar',
      is24x7: true,
      vehicleType: 'Basic Life Support',
      notes: 'Hospital-based ambulance for critical transfers.',
    ),
    TransportContact(
      name: 'Dahanu Sub-District Ambulance',
      type: 'ambulance',
      phone: '02528-222211',
      area: 'Dahanu',
      is24x7: true,
      vehicleType: 'Basic Life Support',
    ),
    TransportContact(
      name: 'Ramu Auto — Palghar Station',
      type: 'auto',
      phone: '+91 98765 11111',
      area: 'Palghar',
      is24x7: false,
      vehicleType: 'Auto Rickshaw',
      notes: 'Available 6am–10pm. Speaks Marathi & Hindi.',
    ),
    TransportContact(
      name: 'Suresh Taxi — Dahanu',
      type: 'driver',
      phone: '+91 97654 22222',
      area: 'Dahanu',
      is24x7: false,
      vehicleType: 'Car (Hatchback)',
      notes: 'Knows all hospital routes in Dahanu & Palghar.',
    ),
    TransportContact(
      name: 'ASHA Worker Sushila — Kasa Village',
      type: 'volunteer',
      phone: '+91 94321 33333',
      area: 'Kasa',
      is24x7: false,
      notes: 'ASHA worker. Can assist with transport coordination and referrals.',
    ),
    TransportContact(
      name: 'Anand Auto — Jawhar',
      type: 'auto',
      phone: '+91 93214 44444',
      area: 'Jawhar',
      is24x7: false,
      vehicleType: 'Auto Rickshaw',
    ),
    TransportContact(
      name: 'Village Health Worker Dinesh — Vikramgad',
      type: 'volunteer',
      phone: '+91 92103 55555',
      area: 'Vikramgad',
      is24x7: false,
      notes: 'Community health volunteer. Can arrange group transport.',
    ),
    TransportContact(
      name: 'Shyam Taxi — Vasai',
      type: 'driver',
      phone: '+91 91092 66666',
      area: 'Vasai',
      is24x7: true,
      vehicleType: 'Sedan',
      notes: 'Available 24/7 for hospital runs in Vasai–Virar area.',
    ),
  ];

  static int get _now =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
