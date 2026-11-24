import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'screens/home_screen.dart';
import 'theme/app_theme.dart'; // تأكد من وجود هذا الملف الذي أرسلته سابقاً في نفس المسار

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  
  // إعداد الإشعارات
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // تأكد من وجود الأيقونة
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  // طلب إذن الإشعارات لأندرويد 13 فما فوق
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MuslimAdhkarApp());
}

class MuslimAdhkarApp extends StatefulWidget {
  const MuslimAdhkarApp({super.key});

  @override
  State<MuslimAdhkarApp> createState() => MuslimAdhkarAppStat();

  static MuslimAdhkarAppStat? of(BuildContext context) =>
      context.findAncestorStateOfType<MuslimAdhkarAppStat>();
}

class MuslimAdhkarAppStat extends State<MuslimAdhkarApp> {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
      _fontScale = prefs.getDouble('fontScale') ?? 1.0;
    });
  }

  void updateSettings(ThemeMode mode, double scale) async {
    setState(() {
      _themeMode = mode;
      _fontScale = scale;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', mode.index);
    prefs.setDouble('fontScale', scale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مسلم: أذكار وتسبيح',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'AE'), // فرض اللغة العربية
      supportedLocales: const [Locale('ar', 'AE')],
      
      // استخدام الثيمات التي عرفناها في ملف AppTheme
      theme: AppTheme.lightTheme(_fontScale),
      darkTheme: AppTheme.darkTheme(_fontScale),
      themeMode: _themeMode,
      
      home: const HomeScreen(), // الشاشة الرئيسية
    );
  }
}

