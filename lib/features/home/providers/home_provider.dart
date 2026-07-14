import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder Home state — extended in Phase 5+ when dashboard
/// shows real data (nearby hospital, last triage result, etc.)
class HomeState {
  final bool isLoading;
  final String? error;

  const HomeState({this.isLoading = false, this.error});

  HomeState copyWith({bool? isLoading, String? error}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  // Phase 5+: load nearby hospital, last triage result, etc.
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(isLoading: false);
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
