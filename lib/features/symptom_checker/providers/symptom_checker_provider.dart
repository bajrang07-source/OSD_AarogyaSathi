import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/triage_result_model.dart';
import '../../../services/ai/triage_engine.dart';
import '../../../services/db/database_service.dart';

/// State for the Symptom Checker module (Phase 3: rule-based triage).
class SymptomCheckerState {
  final List<String> selectedSymptoms;
  final TriageResult? result;
  final bool isLoading;
  final String? error;

  const SymptomCheckerState({
    this.selectedSymptoms = const [],
    this.result,
    this.isLoading = false,
    this.error,
  });

  SymptomCheckerState copyWith({
    List<String>? selectedSymptoms,
    TriageResult? result,
    bool clearResult = false,
    bool? isLoading,
    String? error,
  }) {
    return SymptomCheckerState(
      selectedSymptoms: selectedSymptoms ?? this.selectedSymptoms,
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SymptomCheckerNotifier extends StateNotifier<SymptomCheckerState> {
  final TriageEngine _engine;

  SymptomCheckerNotifier(this._engine)
      : super(const SymptomCheckerState());

  /// Toggle a symptom tag on/off.
  void toggleSymptom(String tag) {
    final current = List<String>.from(state.selectedSymptoms);
    if (current.contains(tag)) {
      current.remove(tag);
    } else {
      current.add(tag);
    }
    state = state.copyWith(
      selectedSymptoms: current,
      clearResult: true, // clear old result when symptoms change
    );
  }

  /// Clear all selected symptoms and result.
  void reset() {
    state = const SymptomCheckerState();
  }

  /// Run the rule engine on the currently selected symptoms and save the log.
  Future<void> runTriage() async {
    if (state.selectedSymptoms.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = _engine.evaluate(state.selectedSymptoms);

      // Persist to triage_logs table (non-blocking)
      DatabaseService.instance.insert(
        DatabaseService.tableTriageLogs,
        result.toLogMap(),
      );

      state = state.copyWith(result: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final triageEngineProvider = Provider<TriageEngine>((ref) {
  return TriageEngine.instance;
});

final symptomCheckerProvider =
    StateNotifierProvider<SymptomCheckerNotifier, SymptomCheckerState>((ref) {
  return SymptomCheckerNotifier(ref.watch(triageEngineProvider));
});
