import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/movie_release.dart';

class MovieDetailsDialog extends StatelessWidget {
  final MovieRelease movieRelease;
  final VoidCallback? onLoadDetails;

  const MovieDetailsDialog({
    super.key,
    required this.movieRelease,
    this.onLoadDetails,
  });

  @override
  Widget build(BuildContext context) {
    final movie = movieRelease.movie;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.movie,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '영화 상세 정보',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // 내용
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 포스터와 기본 정보
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 포스터
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: movie.posterUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: movie.posterUrl,
                                  width: 120,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 120,
                                    height: 180,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                    child: Icon(
                                      Icons.movie,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      size: 48,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        width: 120,
                                        height: 180,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                        child: Icon(
                                          Icons.movie,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          size: 48,
                                        ),
                                      ),
                                )
                              : Container(
                                  width: 120,
                                  height: 180,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceVariant,
                                  child: Icon(
                                    Icons.movie,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    size: 48,
                                  ),
                                ),
                        ),

                        const SizedBox(width: 16),

                        // 기본 정보
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 제목
                              Text(
                                movie.title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 8),

                              // 원제목
                              if (movie.originalTitle != null &&
                                  movie.originalTitle != movie.title)
                                Text(
                                  movie.originalTitle!,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),

                              const SizedBox(height: 12),

                              // 개봉일
                              _buildInfoRow(
                                context,
                                Icons.calendar_today,
                                '개봉일',
                                DateFormat(
                                  'yyyy년 M월 d일 (E)',
                                  'ko',
                                ).format(movieRelease.releaseDate),
                              ),

                              const SizedBox(height: 8),

                              // 평점
                              if (movie.voteAverage != null &&
                                  movie.voteAverage! > 0)
                                _buildInfoRow(
                                  context,
                                  Icons.star,
                                  '평점',
                                  '${movie.voteAverage!.toStringAsFixed(1)} (${movie.voteCount ?? 0}명)',
                                ),

                              const SizedBox(height: 8),

                              // 언어
                              if (movie.originalLanguage != null)
                                _buildInfoRow(
                                  context,
                                  Icons.language,
                                  '언어',
                                  movie.originalLanguage!.toUpperCase(),
                                ),

                              const SizedBox(height: 8),

                              // 성인 등급
                              if (movie.adult)
                                _buildInfoRow(
                                  context,
                                  Icons.warning,
                                  '등급',
                                  '성인',
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 줄거리
                    if (movie.overview.isNotEmpty) ...[
                      Text(
                        '줄거리',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 장르
                    if (movie.genreIds.isNotEmpty) ...[
                      Text(
                        '장르',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: movie.genreIds
                            .map((id) => _getGenreChip(context, id))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // TMDB 출처 표시
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.movie,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Powered by TMDB',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: 영화 상세 정보 새로고침
                            onLoadDetails?.call();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('새로고침'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            // TODO: 영화 상세 정보를 외부 앱에서 열기
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('더 보기'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _getGenreChip(BuildContext context, int genreId) {
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

    final genreName = genreMap[genreId] ?? '기타';

    return Chip(
      label: Text(genreName),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: 12,
      ),
    );
  }
}
