import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'utils/theme.dart';
import 'views/movie_calendar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 로케일 데이터 초기화
  await initializeDateFormatting('ko_KR', null);

  runApp(const MovieCalendarApp());
}

class MovieCalendarApp extends StatefulWidget {
  const MovieCalendarApp({super.key});

  @override
  State<MovieCalendarApp> createState() => _MovieCalendarAppState();
}

class _MovieCalendarAppState extends State<MovieCalendarApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool('isDarkMode');
      if (isDarkMode != null) {
        setState(() {
          _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
        });
      }
    } catch (e) {
      // 기본값 사용
    } finally {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _toggleTheme() async {
    final newThemeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    setState(() {
      _themeMode = newThemeMode;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', newThemeMode == ThemeMode.dark);
    } catch (e) {
      // 테마 설정 저장 실패 시 무시
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: '영화 개봉일 달력',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: MovieCalendarScreen(onToggleTheme: _toggleTheme),
    );
  }
}
