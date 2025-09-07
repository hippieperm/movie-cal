import 'movie.dart';

class MovieRelease {
  final Movie movie;
  final DateTime releaseDate;
  final String? releaseType; // 'theatrical', 'digital', 'physical' 등

  MovieRelease({
    required this.movie,
    required this.releaseDate,
    this.releaseType,
  });

  @override
  String toString() {
    return 'MovieRelease{movie: ${movie.title}, releaseDate: $releaseDate}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MovieRelease &&
        other.movie == movie &&
        other.releaseDate == releaseDate;
  }

  @override
  int get hashCode => movie.hashCode ^ releaseDate.hashCode;
}
