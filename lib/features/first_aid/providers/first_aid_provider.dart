import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/first_aid_topic_model.dart';
import '../../../data/repositories/first_aid_repository.dart';

/// State for the First Aid module.
class FirstAidState {
  final List<FirstAidTopic> topics;
  final List<FirstAidTopic> favourites;
  final String query;
  final bool isLoading;
  final String? error;

  const FirstAidState({
    this.topics = const [],
    this.favourites = const [],
    this.query = '',
    this.isLoading = false,
    this.error,
  });

  FirstAidState copyWith({
    List<FirstAidTopic>? topics,
    List<FirstAidTopic>? favourites,
    String? query,
    bool? isLoading,
    String? error,
  }) {
    return FirstAidState(
      topics: topics ?? this.topics,
      favourites: favourites ?? this.favourites,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FirstAidNotifier extends StateNotifier<FirstAidState> {
  final FirstAidRepository _repo;

  FirstAidNotifier(this._repo) : super(const FirstAidState());

  /// Initial load from SQLite.
  Future<void> loadTopics() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final topics = await _repo.getAll();
      final favourites = await _repo.getFavourites();
      state = state.copyWith(
        topics: topics,
        favourites: favourites,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Filter topics by query (client-side, instant, fully offline).
  Future<void> setQuery(String q) async {
    state = state.copyWith(query: q);
    if (q.isEmpty) {
      final topics = await _repo.getAll();
      state = state.copyWith(topics: topics);
    } else {
      final topics = await _repo.search(q);
      state = state.copyWith(topics: topics);
    }
  }

  /// Toggle favourite for a topic and refresh the favourites list.
  Future<void> toggleFavourite(int topicId) async {
    await _repo.toggleFavourite(topicId);
    final favourites = await _repo.getFavourites();
    state = state.copyWith(favourites: favourites);
  }

  /// Check if a specific topic is favourited.
  bool isFavourite(int topicId) {
    return state.favourites.any((f) => f.id == topicId);
  }
}

final firstAidRepositoryProvider = Provider<FirstAidRepository>((ref) {
  return FirstAidRepository.instance;
});

final firstAidProvider =
    StateNotifierProvider<FirstAidNotifier, FirstAidState>((ref) {
  return FirstAidNotifier(ref.watch(firstAidRepositoryProvider));
});
