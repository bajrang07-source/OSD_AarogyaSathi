import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/transport_contact_model.dart';
import '../../../data/repositories/transport_repository.dart';

/// State for the Transport & Volunteers module (Phase 5).
class TransportState {
  final List<TransportContact> contacts;
  final List<TransportContact> filtered;
  final String? activeFilter;
  final bool isLoading;
  final String? error;

  const TransportState({
    this.contacts = const [],
    this.filtered = const [],
    this.activeFilter,
    this.isLoading = false,
    this.error,
  });

  TransportState copyWith({
    List<TransportContact>? contacts,
    List<TransportContact>? filtered,
    String? activeFilter,
    bool clearFilter = false,
    bool? isLoading,
    String? error,
  }) {
    return TransportState(
      contacts: contacts ?? this.contacts,
      filtered: filtered ?? this.filtered,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TransportNotifier extends StateNotifier<TransportState> {
  final TransportRepository _repo;

  TransportNotifier(this._repo) : super(const TransportState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final all = await _repo.getAll();
      state = state.copyWith(
        contacts: all,
        filtered: _applyFilter(all, state.activeFilter),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setFilter(String? type) {
    final filtered = _applyFilter(state.contacts, type);
    state = state.copyWith(
      filtered: filtered,
      activeFilter: type,
      clearFilter: type == null,
    );
  }

  List<TransportContact> _applyFilter(List<TransportContact> all, String? type) {
    if (type == null) return all;
    return all.where((c) => c.type == type).toList();
  }
}

final transportProvider =
    StateNotifierProvider<TransportNotifier, TransportState>((ref) {
  return TransportNotifier(TransportRepository.instance);
});
