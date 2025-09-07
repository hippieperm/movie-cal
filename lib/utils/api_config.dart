class ApiConfig {
  // TMDB API 키를 여기에 설정하세요
  // https://www.themoviedb.org/settings/api 에서 무료 API 키를 발급받을 수 있습니다
  static const String tmdbApiKey = 'dfa2e4219694b23a244aea3ff4c67098';

  // API 키가 설정되었는지 확인
  static bool get isApiKeySet =>
      tmdbApiKey != 'YOUR_TMDB_API_KEY_HERE' && tmdbApiKey.isNotEmpty;

  // API 키 설정 안내 메시지
  static String get apiKeySetupMessage =>
      'TMDB API 키가 설정되지 않았습니다.\n'
      'lib/utils/api_config.dart 파일에서 YOUR_TMDB_API_KEY_HERE를 '
      '실제 API 키로 교체해주세요.\n\n'
      'API 키 발급: https://www.themoviedb.org/settings/api';
}
