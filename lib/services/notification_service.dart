import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _popupChannel =
      AndroidNotificationChannel(
    'adhkar_popup_channel',
    'الأذكار المنبثقة الدورية',
    description: 'تنبيهات الأذكار المنبثقة أعلى الشاشة',
    importance: Importance.high,
    playSound: true,
  );

  static const AndroidNotificationChannel _dailyChannel =
      AndroidNotificationChannel(
    'adhkar_daily_channel',
    'أذكار الصباح والمساء',
    description: 'تذكير يومي بأذكار الصباح والمساء',
    importance: Importance.high,
    playSound: true,
  );

  static Future<void> init() async {
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Aden'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);

    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.createNotificationChannel(_popupChannel);
    await androidPlugin?.createNotificationChannel(_dailyChannel);
  }

  static Future<List>> _loadEligibleAdhkar() async {
    try {
      final raw = await rootBundle.loadString('assets/data/adhkar.json');
      final List<dynamic> decoded = json.decode(raw);
      final eligible = decoded
          .whereType>()
          .where((item) => item['popup_eligible'] == true)
          .toList();
      if (eligible.isNotEmpty) return eligible;
      return decoded.whereType>().toList();
    } catch (_) {
      return >[
        <String, dynamic>{
          'category': 'ذكر منبثق',
          'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        }
      ];
    }
  }

  static Future<void> showInstantTestNotification() async {
    final list = await _loadEligibleAdhkar();
    final item = list[Random().nextInt(list.length)];
    final String body =
        (item['text'] ?? 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ').toString();
    final String title = (item['category'] ?? 'ذكر منبثق').toString();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'adhkar_popup_channel',
      'الأذكار المنبثقة الدورية',
      channelDescription: 'تنبيهات الأذكار المنبثقة أعلى الشاشة',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ذكر منبثق',
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      999,
      title,
      body,
      details,
    );
  }

  static Future<void> rescheduleAll() async {
    await _notificationsPlugin.cancelAll();

    final prefs = await SharedPreferences.getInstance();
    final bool generalEnabled = prefs.getBool('generalNotifications') ?? true;
    if (!generalEnabled) {
      return;
    }

    final bool periodicEnabled = prefs.getBool('periodicNotifications') ?? true;
    final int intervalMinutes = prefs.getInt('intervalMinutes') ?? 30;
    final bool morningEnabled = prefs.getBool('morningNotifications') ?? true;
    final bool eveningEnabled = prefs.getBool('eveningNotifications') ?? true;
    final int morningHour = prefs.getInt('morningHour') ?? 8;
    final int morningMinute = prefs.getInt('morningMinute') ?? 0;
    final int eveningHour = prefs.getInt('eveningHour') ?? 17;
    final int eveningMinute = prefs.getInt('eveningMinute') ?? 0;

    final list = await _loadEligibleAdhkar();
    final random = Random();

    if (periodicEnabled && list.isNotEmpty) {
      const int maxSchedules = 24;
      for (int i = 1; i <= maxSchedules; i++) {
        final scheduledTime = tz.TZDateTime.now(tz.local)
            .add(Duration(minutes: intervalMinutes * i));
        final item = list[random.nextInt(list.length)];
        final String title = (item['category'] ?? 'ذكر منبثق').toString();
        final String body = (item['text'] ?? '').toString();
        if (body.isEmpty) continue;

        await _notificationsPlugin.zonedSchedule(
          100 + i,
          title,
          body,
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'adhkar_popup_channel',
              'الأذكار المنبثقة الدورية',
              channelDescription: 'تنبيهات الأذكار المنبثقة أعلى الشاشة',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }

    if (morningEnabled) {
      await _scheduleDailyAt(
        id: 1,
        title: 'أذكار الصباح',
        body: 'حان وقت قراءة أذكار الصباح، جعلها الله نوراً وبركة ليومك.',
        hour: morningHour,
        minute: morningMinute,
      );
    }

    if (eveningEnabled) {
      await _scheduleDailyAt(
        id: 2,
        title: 'أذكار المساء',
        body: 'حان وقت قراءة أذكار المساء، حفظك الله ورعاك.',
        hour: eveningHour,
        minute: eveningMinute,
      );
    }
  }

  static Future<void> _scheduleDailyAt({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'adhkar_daily_channel',
          'أذكار الصباح والمساء',
          channelDescription: 'تذكير يومي بأذكار الصباح والمساء',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
