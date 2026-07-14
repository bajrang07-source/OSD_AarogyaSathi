import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/hospital_model.dart';
import '../../../data/repositories/hospital_repository.dart';

/// State for the Hospitals module.
class HospitalsState {
  final List<Hospital> hospitals;
  final String query;
  final bool isLoading;
  final bool showEmergencyOnly;
  final String? error;

  const HospitalsState({
    this.hospitals = const [],
    this.query = '',
    this.isLoading = false,
    this.showEmergencyOnly = false,
    this.error,
  });

  HospitalsState copyWith({
    List<Hospital>? hospitals,
    String? query,
    bool? isLoading,
    bool? showEmergencyOnly,
    String? error,
  }) {
    return HospitalsState(
      hospitals: hospitals ?? this.hospitals,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      showEmergencyOnly: showEmergencyOnly ?? this.showEmergencyOnly,
      error: error,
    );
  }
}

class HospitalsNotifier extends StateNotifier<HospitalsState> {
  final HospitalRepository _repo;

  HospitalsNotifier(this._repo) : super(const HospitalsState());

  Future<void> loadHospitals() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final hospitals = await _repo.getAll();
      state = state.copyWith(hospitals: hospitals, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setQuery(String q) async {
    state = state.copyWith(query: q);
    if (q.isEmpty) {
      final hospitals = state.showEmergencyOnly
          ? await _repo.getEmergency()
          : await _repo.getAll();
      state = state.copyWith(hospitals: hospitals);
    } else {
      final results = await _repo.search(q);
      final hospitals = state.showEmergencyOnly
          ? results.where((h) => h.emergencyCapable).toList()
          : results;
      state = state.copyWith(hospitals: hospitals);
    }
  }

  Future<void> toggleEmergencyFilter() async {
    final showEmergency = !state.showEmergencyOnly;
    state = state.copyWith(showEmergencyOnly: showEmergency, isLoading: true);
    try {
      List<Hospital> hospitals;
      if (state.query.isNotEmpty) {
        final results = await _repo.search(state.query);
        hospitals = showEmergency
            ? results.where((h) => h.emergencyCapable).toList()
            : results;
      } else {
        hospitals =
            showEmergency ? await _repo.getEmergency() : await _repo.getAll();
      }
      state = state.copyWith(hospitals: hospitals, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final hospitalRepositoryProvider = Provider<HospitalRepository>((ref) {
  return HospitalRepository.instance;
});

final hospitalsProvider =
    StateNotifierProvider<HospitalsNotifier, HospitalsState>((ref) {
  return HospitalsNotifier(ref.watch(hospitalRepositoryProvider));
});
