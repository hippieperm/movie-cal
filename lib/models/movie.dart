class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final List<int> genreIds;
  final String? originalLanguage;
  final String? originalTitle;
  final bool adult;
  final double? popularity;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    required this.genreIds,
    this.originalLanguage,
    this.originalTitle,
    required this.adult,
    this.popularity,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate:
          json['release_date'] != null && json['release_date'].isNotEmpty
          ? DateTime.tryParse(json['release_date'])
          : null,
      voteAverage: json['vote_average']?.toDouble(),
      voteCount: json['vote_count'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      adult: json['adult'] ?? false,
      popularity: json['popularity']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate?.toIso8601String().split('T')[0],
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'adult': adult,
      'popularity': popularity,
    };
  }

  String get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : '';

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, releaseDate: $releaseDate}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
