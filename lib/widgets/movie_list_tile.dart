import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_release.dart';

class MovieListTile extends StatelessWidget {
  final MovieRelease movieRelease;
  final VoidCallback? onTap;

  const MovieListTile({super.key, required this.movieRelease, this.onTap});

  @override
  Widget build(BuildContext context) {
    final movie = movieRelease.movie;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 포스터 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: movie.posterUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: movie.posterUrl,
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 90,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.movie,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 90,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.movie,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 90,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.movie,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),

              const SizedBox(width: 12),

              // 영화 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // 개봉일
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatReleaseDate(movieRelease.releaseDate),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // 평점
                    if (movie.voteAverage != null && movie.voteAverage! > 0)
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage!.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                          ),
                          if (movie.voteCount != null && movie.voteCount! > 0)
                            Text(
                              ' (${movie.voteCount})',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.5),
                                  ),
                            ),
                        ],
                      ),

                    const SizedBox(height: 4),

                    // 장르 (간단히 표시)
                    if (movie.genreIds.isNotEmpty)
                      Text(
                        '장르: ${_getGenreText(movie.genreIds)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // 화살표 아이콘
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatReleaseDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  String _getGenreText(List<int> genreIds) {
    // 간단한 장르 매핑 (실제로는 API에서 장르 정보를 가져와야 함)
    final genreMap = {
      28: '액션',
      12: '모험',
      16: '애니메이션',
      35: '코미디',
      80: '범죄',
      99: '다큐멘터리',
      18: '드라마',
      10751: '가족',
      14: '판타지',
      36: '역사',
      27: '공포',
      10402: '음악',
      9648: '미스터리',
      10749: '로맨스',
      878: 'SF',
      10770: 'TV 영화',
      53: '스릴러',
      10752: '전쟁',
      37: '서부',
    };

    final genres = genreIds
        .map((id) => genreMap[id] ?? '기타')
        .take(2)
        .join(', ');

    return genres.isNotEmpty ? genres : '기타';
  }
}
