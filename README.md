# 영화 개봉일 달력 앱

Flutter로 개발된 영화 개봉일 달력 앱입니다. TMDB API를 사용하여 실제 영화 데이터를 가져와 달력에 표시합니다.

## 주요 기능

- 📅 **달력 뷰**: 월별 영화 개봉일을 달력 형태로 표시
- 🎬 **영화 정보**: 포스터, 제목, 평점, 장르 등 상세 정보 제공
- 🌙 **다크모드**: 라이트/다크 테마 지원
- 🎨 **머터리얼3**: 최신 머터리얼 디자인 적용
- 🏗️ **MVVM 구조**: 깔끔한 아키텍처로 유지보수성 향상

## 시작하기

### 1. 의존성 설치

```bash
flutter pub get
```

### 2. TMDB API 키 설정

1. [TMDB 웹사이트](https://www.themoviedb.org/settings/api)에서 무료 API 키를 발급받습니다.
2. `lib/utils/api_config.dart` 파일을 열고 `YOUR_TMDB_API_KEY_HERE`를 실제 API 키로 교체합니다.

```dart
class ApiConfig {
  static const String tmdbApiKey = '여기에_실제_API_키_입력';
  // ...
}
```

### 3. 앱 실행

```bash
flutter run
```

## 프로젝트 구조

```
lib/
├── models/           # 데이터 모델
│   ├── movie.dart
│   └── movie_release.dart
├── viewmodels/       # 비즈니스 로직
│   └── movie_calendar_viewmodel.dart
├── views/            # 화면
│   └── movie_calendar_screen.dart
├── widgets/          # 재사용 가능한 위젯
│   ├── movie_calendar.dart
│   ├── movie_list_tile.dart
│   └── movie_details_dialog.dart
├── services/         # API 서비스
│   └── movie_api_service.dart
├── utils/            # 유틸리티
│   ├── theme.dart
│   └── api_config.dart
└── main.dart         # 앱 진입점
```

## 사용된 패키지

- `provider`: 상태 관리
- `table_calendar`: 달력 위젯
- `http`: API 통신
- `cached_network_image`: 이미지 캐싱
- `intl`: 날짜 포맷팅
- `shared_preferences`: 설정 저장

## 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다.
