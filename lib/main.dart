import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await NotificationService.rescheduleAll();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MuslimAdhkarApp());
}

class MuslimAdhkarApp extends StatefulWidget {
  const MuslimAdhkarApp({super.key});

  @override
  State<MuslimAdhkarApp> createState() => MuslimAdhkarAppState();

  static MuslimAdhkarAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MuslimAdhkarAppState>();
}

class MuslimAdhkarAppState extends State<MuslimAdhkarApp> {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final int savedThemeIndex = prefs.getInt('themeMode') ?? 0;
    final ThemeMode safeThemeMode =
        (savedThemeIndex >= 0 && savedThemeIndex < ThemeMode.values.length)
            ? ThemeMode.values[savedThemeIndex]
            : ThemeMode.system;

    setState(() {
      _themeMode = safeThemeMode;
      _fontScale = prefs.getDouble('fontScale') ?? 1.0;
    });
  }

  Future<void> updateSettings(ThemeMode mode, double scale) async {
    setState(() {
      _themeMode = mode;
      _fontScale = scale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    await prefs.setDouble('fontScale', scale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مسلم: أذكار وتسبيح',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'AE'),
      supportedLocales: const [Locale('ar', 'AE')],
      theme: AppTheme.lightTheme(_fontScale),
      darkTheme: AppTheme.darkTheme(_fontScale),
      themeMode: _themeMode,
      home: const HomeScreen(),
    );
  }
}
