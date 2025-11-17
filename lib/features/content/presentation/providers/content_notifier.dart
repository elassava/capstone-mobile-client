import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/content.dart';
import '../../domain/usecases/get_all_contents_usecase.dart';
import '../../domain/usecases/get_featured_contents_usecase.dart';
import '../../domain/usecases/get_contents_by_type_usecase.dart';

/// Content State
class ContentState {
  final bool isLoading;
  final List<Content> contents;
  final List<Content> featuredContents;
  final List<Content> movies;
  final List<Content> tvSeries;
  final String? error;
  final bool isSuccess;

  const ContentState({
    this.isLoading = false,
    this.contents = const [],
    this.featuredContents = const [],
    this.movies = const [],
    this.tvSeries = const [],
    this.error,
    this.isSuccess = false,
  });

  ContentState copyWith({
    bool? isLoading,
    List<Content>? contents,
    List<Content>? featuredContents,
    List<Content>? movies,
    List<Content>? tvSeries,
    String? error,
    bool? isSuccess,
  }) {
    return ContentState(
      isLoading: isLoading ?? this.isLoading,
      contents: contents ?? this.contents,
      featuredContents: featuredContents ?? this.featuredContents,
      movies: movies ?? this.movies,
      tvSeries: tvSeries ?? this.tvSeries,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Content Notifier - Manages content state
class ContentNotifier extends StateNotifier<ContentState> {
  final GetAllContentsUseCase _getAllContentsUseCase;
  final GetFeaturedContentsUseCase _getFeaturedContentsUseCase;
  final GetContentsByTypeUseCase _getContentsByTypeUseCase;

  ContentNotifier(
    this._getAllContentsUseCase,
    this._getFeaturedContentsUseCase,
    this._getContentsByTypeUseCase,
  ) : super(const ContentState());

  /// Fetch all contents
  Future<void> fetchAllContents() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final contents = await _getAllContentsUseCase();
      // Filter only published and active contents
      final publishedContents = contents
          .where((c) => c.isPublished && c.isActive)
          .toList();

      // Separate movies and TV series
      final movies = publishedContents.where((c) => c.isMovie).toList();
      final tvSeries = publishedContents.where((c) => c.isTvSeries).toList();

      state = state.copyWith(
        isLoading: false,
        contents: publishedContents,
        movies: movies,
        tvSeries: tvSeries,
        error: null,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  /// Fetch featured contents
  Future<void> fetchFeaturedContents() async {
    try {
      final featuredContents = await _getFeaturedContentsUseCase();
      state = state.copyWith(
        featuredContents: featuredContents,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Fetch contents by type
  Future<void> fetchContentsByType(String contentType) async {
    try {
      final contents = await _getContentsByTypeUseCase(contentType);
      final publishedContents = contents
          .where((c) => c.isPublished && c.isActive)
          .toList();

      if (contentType == 'MOVIE') {
        state = state.copyWith(movies: publishedContents);
      } else if (contentType == 'TV_SERIES') {
        state = state.copyWith(tvSeries: publishedContents);
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Reset state
  void reset() {
    state = const ContentState();
  }
}



