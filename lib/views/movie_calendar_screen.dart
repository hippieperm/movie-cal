import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/movie_calendar_viewmodel.dart';
import '../widgets/movie_calendar.dart';

class MovieCalendarScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const MovieCalendarScreen({super.key, this.onToggleTheme});

  @override
  State<MovieCalendarScreen> createState() => _MovieCalendarScreenState();
}

class _MovieCalendarScreenState extends State<MovieCalendarScreen> {
  late MovieCalendarViewModel _viewModel;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    _viewModel = MovieCalendarViewModel();
    _viewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MovieCalendarViewModel>(
      create: (_) => _viewModel,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('영화 개봉일 달력'),
            actions: [
              // 새로고침 버튼
              Consumer<MovieCalendarViewModel>(
                builder: (context, viewModel, child) {
                  return IconButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => viewModel.refreshCurrentMonth(),
                    icon: viewModel.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                  );
                },
              ),

              // 다크모드 토글 버튼
              IconButton(
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              ),

              // 설정 메뉴
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'about') {
                    _showAboutDialog(context);
                  } else if (value == 'tmdb') {
                    _showTmdbInfo(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 8),
                        Text('앱 정보'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'tmdb',
                    child: Row(
                      children: [
                        Icon(Icons.movie),
                        SizedBox(width: 8),
                        Text('Powered by TMDB'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Consumer<MovieCalendarViewModel>(
            builder: (context, viewModel, child) {
              // 에러 상태 처리
              if (viewModel.errorMessage != null) {
                return _buildErrorState(context, viewModel);
              }

              // 로딩 상태 처리
              if (viewModel.isLoading && viewModel.movieReleases.isEmpty) {
                return _buildLoadingState(context);
              }

              // 메인 달력 UI
              return Column(
                children: [
                  Expanded(child: MovieCalendar(viewModel: viewModel)),
                  // 하단 TMDB 출처 표시
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant.withOpacity(0.5),
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('영화 데이터를 불러오는 중...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    MovieCalendarViewModel viewModel,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '오류가 발생했습니다',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? '알 수 없는 오류가 발생했습니다.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => viewModel.clearError(),
                  icon: const Icon(Icons.close),
                  label: const Text('닫기'),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => viewModel.refreshCurrentMonth(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 시도'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: '영화 개봉일 달력',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.movie,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        const Text(
          'Flutter로 개발된 영화 개봉일 달력 앱입니다.\n'
          'TMDB API를 사용하여 실제 영화 데이터를 제공합니다.',
        ),
        const SizedBox(height: 16),
        const Text('주요 기능:', style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('• 월별 영화 개봉일 달력'),
        const Text('• 영화 상세 정보'),
        const Text('• 다크모드 지원'),
        const Text('• 머터리얼3 디자인'),
      ],
    );
  }

  void _showTmdbInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.movie, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Powered by TMDB'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '이 앱은 The Movie Database (TMDB) API를 사용하여 영화 데이터를 제공합니다.',
            ),
            const SizedBox(height: 16),
            const Text('TMDB는 영화 및 TV 프로그램에 대한 정보를 제공하는 무료 데이터베이스입니다.'),
            const SizedBox(height: 16),
            const Text(
              '더 자세한 정보는 다음 링크를 방문하세요:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // TODO: 웹 브라우저로 TMDB 사이트 열기
              },
              child: Text(
                'https://www.themoviedb.org',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    const maxDuration = Duration(seconds: 2);
    final isWarning =
        _lastBackPressed == null ||
        now.difference(_lastBackPressed!) > maxDuration;

    if (isWarning) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('뒤로가기를 한 번 더 누르면 앱이 종료됩니다'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return false;
    } else {
      return true;
    }
  }
}
