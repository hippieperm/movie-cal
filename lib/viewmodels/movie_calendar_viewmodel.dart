import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../models/movie_release.dart';
import '../services/movie_api_service.dart';

class MovieCalendarViewModel extends ChangeNotifier {
  final MovieApiService _apiService = MovieApiService();

  // 상태 변수들
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  Map<DateTime, List<MovieRelease>> _movieReleases = {};
  bool _isLoading = false;
  String? _errorMessage;
  Movie? _selectedMovie;

  // Getters
  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  Map<DateTime, List<MovieRelease>> get movieReleases => _movieReleases;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Movie? get selectedMovie => _selectedMovie;

  // 특정 날짜의 영화 목록 가져오기
  List<MovieRelease> getMoviesForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _movieReleases[dateKey] ?? [];
  }

  // 선택된 날짜의 영화 목록 가져오기
  List<MovieRelease> get selectedDateMovies => getMoviesForDate(_selectedDate);

  // 날짜 선택
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // 포커스된 날짜 변경 (달력에서 월 변경 시)
  void changeFocusedDate(DateTime date) {
    _focusedDate = date;
    _loadMoviesForMonth(date);
    notifyListeners();
  }

  // 특정 월의 영화 데이터 로드
  Future<void> _loadMoviesForMonth(DateTime month) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final movies = await _apiService.getMoviesByMonth(month);

      // 날짜별로 영화를 그룹화
      final Map<DateTime, List<MovieRelease>> groupedMovies = {};
      for (final movieRelease in movies) {
        final dateKey = DateTime(
          movieRelease.releaseDate.year,
          movieRelease.releaseDate.month,
          movieRelease.releaseDate.day,
        );

        if (groupedMovies[dateKey] == null) {
          groupedMovies[dateKey] = [];
        }
        groupedMovies[dateKey]!.add(movieRelease);
      }

      // 기존 데이터와 병합
      _movieReleases.addAll(groupedMovies);
    } catch (e) {
      _setError('영화 데이터를 불러오는 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 영화 상세 정보 로드
  Future<void> loadMovieDetails(int movieId) async {
    try {
      _setLoading(true);
      _clearError();

      final movie = await _apiService.getMovieDetails(movieId);
      _selectedMovie = movie;
    } catch (e) {
      _setError('영화 상세 정보를 불러오는 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 영화 검색
  Future<List<Movie>> searchMovies(String query) async {
    try {
      _setLoading(true);
      _clearError();

      final movies = await _apiService.searchMovies(query);
      return movies;
    } catch (e) {
      _setError('영화 검색 중 오류가 발생했습니다: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // 현재 월의 영화 데이터 새로고침
  Future<void> refreshCurrentMonth() async {
    await _loadMoviesForMonth(_focusedDate);
  }

  // 선택된 영화 초기화
  void clearSelectedMovie() {
    _selectedMovie = null;
    notifyListeners();
  }

  // 에러 메시지 초기화
  void clearError() {
    _clearError();
  }

  // 내부 메서드들
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 초기화
  Future<void> initialize() async {
    await _loadMoviesForMonth(_focusedDate);
  }
}
