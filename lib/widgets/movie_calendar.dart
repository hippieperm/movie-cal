import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/movie_release.dart';
import '../viewmodels/movie_calendar_viewmodel.dart';
import 'movie_list_tile.dart';
import 'movie_details_dialog.dart';

class MovieCalendar extends StatelessWidget {
  final MovieCalendarViewModel viewModel;

  const MovieCalendar({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 달력 위젯
        Card(
          margin: const EdgeInsets.all(16),
          child: TableCalendar<MovieRelease>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: viewModel.focusedDate,
            selectedDayPredicate: (day) {
              return isSameDay(viewModel.selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              viewModel.selectDate(selectedDay);
            },
            onPageChanged: (focusedDay) {
              viewModel.changeFocusedDate(focusedDay);
            },
            eventLoader: (day) {
              return viewModel.getMoviesForDate(day);
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              holidayTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
              markerSize: 6,
              markerMargin: const EdgeInsets.symmetric(horizontal: 1),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle:
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.primary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              weekendStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return null;

                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // 선택된 날짜의 영화 목록
        Expanded(child: _buildSelectedDateMovies(context)),
      ],
    );
  }

  Widget _buildSelectedDateMovies(BuildContext context) {
    final movies = viewModel.selectedDateMovies;
    final selectedDate = viewModel.selectedDate;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 선택된 날짜 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.movie, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  DateFormat('yyyy년 M월 d일 (E)', 'ko').format(selectedDate),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Chip(
                  label: Text('${movies.length}개'),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                ),
              ],
            ),
          ),

          // 영화 목록
          if (movies.isEmpty)
            _buildEmptyState(context)
          else
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movieRelease = movies[index];
                  return MovieListTile(
                    movieRelease: movieRelease,
                    onTap: () => _showMovieDetails(context, movieRelease),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '이 날 개봉하는 영화가 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '다른 날짜를 선택해보세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  void _showMovieDetails(BuildContext context, MovieRelease movieRelease) {
    showDialog(
      context: context,
      builder: (context) => MovieDetailsDialog(
        movieRelease: movieRelease,
        onLoadDetails: () => viewModel.loadMovieDetails(movieRelease.movie.id),
      ),
    );
  }
}
