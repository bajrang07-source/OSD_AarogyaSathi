import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthCardState {
  final bool isUnlocked;
  final bool isLoading;
  final dynamic cardData; // typed in Phase 11

  const HealthCardState({
    this.isUnlocked = false,
    this.isLoading = false,
    this.cardData,
  });

  HealthCardState copyWith({
    bool? isUnlocked,
    bool? isLoading,
    dynamic cardData,
  }) {
    return HealthCardState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isLoading: isLoading ?? this.isLoading,
      cardData: cardData ?? this.cardData,
    );
  }
}

class HealthCardNotifier extends StateNotifier<HealthCardState> {
  HealthCardNotifier() : super(const HealthCardState());

  // Phase 11: biometric/PIN auth + decrypt from secure storage
  Future<void> unlock(String pin) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isLoading: false, isUnlocked: true);
  }

  void lock() {
    state = const HealthCardState();
  }
}

final healthCardProvider =
    StateNotifierProvider<HealthCardNotifier, HealthCardState>((ref) {
  return HealthCardNotifier();
});
