import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_release.dart';
import '../utils/api_config.dart';

class MovieApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static String get _apiKey => ApiConfig.tmdbApiKey;

  // API 키를 설정하는 메서드
  static void setApiKey(String apiKey) {
    // 실제 구현에서는 환경 변수나 설정 파일에서 가져오는 것이 좋습니다
  }

  // 현재 상영 중인 영화 목록 가져오기
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    if (!ApiConfig.isApiKeySet) {
      throw Exception(
        'API 키가 설정되지 않았습니다. lib/utils/api_config.dart 파일을 확인해주세요.',
      );
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/movie/now_playing?api_key=$_apiKey&page=$page&language=ko-KR',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> movies = data['results'];
        return movies.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  // 인기 영화 목록 가져오기
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    if (!ApiConfig.isApiKeySet) {
      throw Exception(
        'API 키가 설정되지 않았습니다. lib/utils/api_config.dart 파일을 확인해주세요.',
      );
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/movie/popular?api_key=$_apiKey&page=$page&language=ko-KR',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> movies = data['results'];
        return movies.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load popular movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching popular movies: $e');
    }
  }

  // 개봉 예정 영화 목록 가져오기
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    if (!ApiConfig.isApiKeySet) {
      throw Exception(
        'API 키가 설정되지 않았습니다. lib/utils/api_config.dart 파일을 확인해주세요.',
      );
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/movie/upcoming?api_key=$_apiKey&page=$page&language=ko-KR',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> movies = data['results'];
        return movies.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load upcoming movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching upcoming movies: $e');
    }
  }

  // 특정 월의 영화 개봉일 정보 가져오기
  Future<List<MovieRelease>> getMoviesByMonth(DateTime month) async {
    if (!ApiConfig.isApiKeySet) {
      throw Exception(
        'API 키가 설정되지 않았습니다. lib/utils/api_config.dart 파일을 확인해주세요.',
      );
    }

    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0);

      final startDateStr = startDate.toIso8601String().split('T')[0];
      final endDateStr = endDate.toIso8601String().split('T')[0];

      final url =
          '$_baseUrl/discover/movie?api_key=$_apiKey&primary_release_date.gte=$startDateStr&primary_release_date.lte=$endDateStr&language=ko-KR&sort_by=release_date.asc';

      print('TMDB API 호출: $url');

      final response = await http.get(Uri.parse(url));

      print('API 응답 상태: ${response.statusCode}');
      print('API 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> movies = data['results'];

        print('받은 영화 수: ${movies.length}');

        final releases = movies
            .map((json) {
              final movie = Movie.fromJson(json);
              if (movie.releaseDate != null) {
                print('영화: ${movie.title} - ${movie.releaseDate}');
                return MovieRelease(
                  movie: movie,
                  releaseDate: movie.releaseDate!,
                  releaseType: 'theatrical',
                );
              }
              return null;
            })
            .where((release) => release != null)
            .cast<MovieRelease>()
            .toList();

        print('처리된 영화 개봉일 수: ${releases.length}');
        return releases;
      } else {
        throw Exception(
          'Failed to load movies by month: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching movies by month: $e');
    }
  }

  // 영화 상세 정보 가져오기
  Future<Movie> getMovieDetails(int movieId) async {
    if (!ApiConfig.isApiKeySet) {
      throw Exception(
        'API 키가 설정되지 않았습니다. lib/utils/api_config.dart 파일을 확인해주세요.',
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=ko-KR'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }

  // 영화 검색
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (!ApiConfig.isApiKeySet) {
      throw Exception(
        'API 키가 설정되지 않았습니다. lib/utils/api_config.dart 파일을 확인해주세요.',
      );
    }

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&query=$encodedQuery&page=$page&language=ko-KR',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> movies = data['results'];
        return movies.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }
}
