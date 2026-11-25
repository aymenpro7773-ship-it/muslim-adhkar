import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../main.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const TodayTab(),
    const AdhkarLibraryTab(),
    const CounterTab(),
    const NotificationsTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'اليوم',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'الأذكار',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'الحسَّابة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'التنبيهات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'المزيد',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: isDark ? Colors.grey : Colors.grey[600],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          elevation: 0,
          selectedLabelStyle: GoogleFonts.ibmPlexSansArabic(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 11),
        ),
      ),
    );
  }
}

// --- تبويب "اليوم" (الرئيسية) ---
class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final hour = DateTime.now().hour;
    final String greeting = hour < 12 ? "صباح الخير" : "مساء الخير";
    final String mainAdhkar = hour < 12 ? "أذكار الصباح" : "أذكار المساء";
    final IconData mainIcon =
        hour < 12 ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.amiri(
                    fontSize: 28,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: colorScheme.secondary.withOpacity(0.2),
                  child: Icon(Icons.mosque, color: colorScheme.secondary),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Icon(mainIcon, size: 50, color: colorScheme.secondary),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mainAdhkar,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "ابدأ قراءة ${mainAdhkar.toLowerCase()} الآن",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.lightSubtext),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: colorScheme.primary.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "قصة وفائدة اليوم",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "قصة الأمانة والبركة",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "اشترى رجل صالح قطعة أرض من رجل آخر، وبينما هو يحفر فيها وجد إناءً مليئاً بالذهب...",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(height: 1.6),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("قراءة القصة كاملة"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- تبويب "الأذكار" (المكتبة الشاملة + الصوتيات) ---
class AdhkarLibraryTab extends StatefulWidget {
  const AdhkarLibraryTab({super.key});

  @override
  State<AdhkarLibraryTab> createState() => _AdhkarLibraryTabState();
}

class _AdhkarLibraryTabState extends State<AdhkarLibraryTab> {
  late Future<List<dynamic>> _adhkarFuture;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _playingUrl;

  @override
  void initState() {
    super.initState();
    _adhkarFuture = _loadAdhkarJson();
  }

  Future<List<dynamic>> _loadAdhkarJson() async {
    final String response =
        await rootBundle.loadString('assets/data/adhkar.json');
    final data = await json.decode(response);
    return data;
  }

  void _playAudio(String url) async {
    if (_isPlaying && _playingUrl == url) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _isPlaying = true;
        _playingUrl = url;
      });
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              labelStyle: GoogleFonts.ibmPlexSansArabic(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 14),
              tabs: const [
                Tab(text: "أذكار الصباح"),
                Tab(text: "أذكار المساء"),
                Tab(text: "الاستغفار والتسبيح"),
                Tab(text: "أدعية وأوراد"),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _adhkarFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('لا توجد أذكار متاحة'));
                  } else {
                    final morning = snapshot.data!
                        .where((e) => e['category'] == 'أذكار الصباح')
                        .toList();
                    final evening = snapshot.data!
                        .where((e) => e['category'] == 'أذكار المساء')
                        .toList();
                    final istighfar = snapshot.data!
                        .where((e) => e['category'] == 'الاستغفار والتسبيح')
                        .toList();
                    final general = snapshot.data!
                        .where((e) =>
                            e['category'] != 'أذكار الصباح' &&
                            e['category'] != 'أذكار المساء' &&
                            e['category'] != 'الاستغفار والتسبيح')
                        .toList();

                    return TabBarView(
                      children: [
                        _buildAdhkarList(morning, true),
                        _buildAdhkarList(evening, true),
                        _buildAdhkarList(istighfar, false),
                        _buildAdhkarList(general, false),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdhkarList(List<dynamic> adhkarList, bool hasAudio) {
    final colorScheme = Theme.of(context).colorScheme;
    const String morningAudioUrl = "https://server8.mp3quran.net/afs/001.mp3";
    const String eveningAudioUrl = "https://server8.mp3quran.net/afs/114.mp3";
    final String categoryLabel = adhkarList.isNotEmpty
        ? adhkarList[0]['category'].toString().split(' ').last
        : 'الأذكار';

    return Column(
      children: [
        if (hasAudio && adhkarList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Card(
              color: colorScheme.secondary.withOpacity(0.1),
              elevation: 0,
              child: ListTile(
                leading: Icon(Icons.headset_mic, color: colorScheme.secondary),
                title: Text(
                  "استمع لأذكار $categoryLabel",
                  style: TextStyle(color: colorScheme.secondary),
                ),
                subtitle: const Text("بصوت الشيخ مشاري العفاسي"),
                trailing: IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: colorScheme.secondary,
                    size: 32,
                  ),
                  onPressed: () => _playAudio(
                    adhkarList[0]['category'] == 'أذكار الصباح'
                        ? morningAudioUrl
                        : eveningAudioUrl,
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            itemCount: adhkarList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final dhikr = adhkarList[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dhikr['text'] ?? '',
                        style: AppTheme.dhikrTextStyle(context, 1.0),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "العدد: ${dhikr['count']}",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              dhikr['reward'] ?? '',
                              style: const TextStyle(
                                color: AppColors.lightSubtext,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- تبويب "الحسَّابة" (المسبحة الإلكترونية) ---
class CounterTab extends StatefulWidget {
  const CounterTab({super.key});

  @override
  State<CounterTab> createState() => _CounterTabState();
}

class _CounterTabState extends State<CounterTab> {
  int _currentCount = 0;
  int _targetCount = 33;
  String _selectedDhikr = "سبحان الله وبحمده";
  final List<String> _dhikrOptions = [
    "سبحان الله وبحمده",
    "أستغفر الله",
    "الحمدلله",
    "صلى الله على محمد",
    "لا إله إلا الله وحده لا شريك له"
  ];

  void _incrementCount() async {
    setState(() {
      _currentCount++;
    });

    if (_currentCount > 0 && _currentCount % _targetCount == 0) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 100);
      }
    }
  }

  void _resetCount() {
    setState(() {
      _currentCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double progress =
        _targetCount > 0 ? (_currentCount % _targetCount) / _targetCount : 0.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedDhikr,
              isExpanded: true,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
              underline: Container(),
              onChanged: (String? newValue) {
                if (newValue == null) return;
                setState(() {
                  _selectedDhikr = newValue;
                  _currentCount = 0;
                  _targetCount = newValue == "أستغفر الله" ? 100 : 33;
                });
              },
              items: _dhikrOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value, textAlign: TextAlign.center)),
                );
              }).toList(),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: _incrementCount,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 15,
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        _currentCount.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        "من $_targetCount",
                        style: const TextStyle(color: AppColors.lightSubtext),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: _resetCount,
              icon: const Icon(Icons.refresh),
              label: const Text("إعادة تعيين"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- تبويب "الإشعارات" (الضوابط والتوقيت والأذكار المنبثقة) ---
class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  bool _generalNotifications = true;
  bool _morningNotifications = true;
  bool _eveningNotifications = true;
  bool _periodicNotifications = true;
  int _intervalMinutes = 30;
  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _generalNotifications = prefs.getBool('generalNotifications') ?? true;
      _morningNotifications = prefs.getBool('morningNotifications') ?? true;
      _eveningNotifications = prefs.getBool('eveningNotifications') ?? true;
      _periodicNotifications = prefs.getBool('periodicNotifications') ?? true;
      _intervalMinutes = prefs.getInt('intervalMinutes') ?? 30;
      _morningTime = TimeOfDay(
        hour: prefs.getInt('morningHour') ?? 8,
        minute: prefs.getInt('morningMinute') ?? 0,
      );
      _eveningTime = TimeOfDay(
        hour: prefs.getInt('eveningHour') ?? 17,
        minute: prefs.getInt('eveningMinute') ?? 0,
      );
    });
  }

  Future<void> _saveAndReschedule(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is int) await prefs.setInt(key, value);
    await NotificationService.rescheduleAll();
  }

  Future<void> _selectTime(BuildContext context, bool isMorning) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? _morningTime : _eveningTime,
    );
    if (picked != null) {
      setState(() {
        if (isMorning) {
          _morningTime = picked;
        } else {
          _eveningTime = picked;
        }
      });
      await _saveAndReschedule(
        isMorning ? 'morningHour' : 'eveningHour',
        picked.hour,
      );
      await _saveAndReschedule(
        isMorning ? 'morningMinute' : 'eveningMinute',
        picked.minute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            "ضبط التنبيهات",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text("تفعيل الإشعارات العامة"),
            value: _generalNotifications,
            onChanged: (bool value) {
              setState(() => _generalNotifications = value);
              _saveAndReschedule('generalNotifications', value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("الأذكار المنبثقة الدورية (100 ذكر)"),
            subtitle: const Text("إظهار ذكر منبثق أعلى الشاشة تلقائياً"),
            value: _periodicNotifications,
            onChanged: (bool value) {
              setState(() => _periodicNotifications = value);
              _saveAndReschedule('periodicNotifications', value);
            },
          ),
          ListTile(
            title: const Text("تكرار الإشعار المنبثق كل:"),
            trailing: DropdownButton<int>(
              value: _intervalMinutes,
              items: const [
                DropdownMenuItem(value: 15, child: Text("15 دقيقة")),
                DropdownMenuItem(value: 30, child: Text("30 دقيقة")),
                DropdownMenuItem(value: 60, child: Text("ساعة واحدة")),
                DropdownMenuItem(value: 120, child: Text("ساعتين")),
                DropdownMenuItem(value: 180, child: Text("3 ساعات")),
              ],
              onChanged: (int? val) {
                if (val != null) {
                  setState(() => _intervalMinutes = val);
                  _saveAndReschedule('intervalMinutes', val);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: OutlinedButton.icon(
              onPressed: () => NotificationService.showInstantTestNotification(),
              icon: const Icon(Icons.notifications_active),
              label: const Text("تجربة ظهور الإشعار المنبثق الآن"),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("تذكير أذكار الصباح"),
            value: _morningNotifications,
            onChanged: (bool value) {
              setState(() => _morningNotifications = value);
              _saveAndReschedule('morningNotifications', value);
            },
          ),
          ListTile(
            title: const Text("وقت أذكار الصباح"),
            subtitle: Text(_morningTime.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context, true),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("تذكير أذكار المساء"),
            value: _eveningNotifications,
            onChanged: (bool value) {
              setState(() => _eveningNotifications = value);
              _saveAndReschedule('eveningNotifications', value);
            },
          ),
          ListTile(
            title: const Text("وقت أذكار المساء"),
            subtitle: Text(_eveningTime.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context, false),
          ),
        ],
      ),
    );
  }
}

// --- تبويب "المزيد" (الإعدادات) ---
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  double _fontScale = 1.0;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _fontScale = prefs.getDouble('fontScale') ?? 1.0;
      _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            "المزيد",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ListTile(
            title: const Text("حجم الخط"),
            subtitle: Slider(
              value: _fontScale,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              label: "${(_fontScale * 100).toInt()}%",
              onChanged: (double value) {
                setState(() => _fontScale = value);
                MuslimAdhkarApp.of(context)?.updateSettings(_themeMode, value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("الوضع الليلي"),
            subtitle: DropdownButton<ThemeMode>(
              value: _themeMode,
              isExpanded: true,
              onChanged: (ThemeMode? newValue) {
                if (newValue != null) {
                  setState(() => _themeMode = newValue);
                  MuslimAdhkarApp.of(context)?.updateSettings(newValue, _fontScale);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text("نظام الهاتف"),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text("فاتح")),
                DropdownMenuItem(value: ThemeMode.dark, child: Text("داكن")),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("مشاركة التطبيق للأجر"),
            subtitle: const Text("انشر رابط التطبيق والدال على الخير كفاعله"),
            trailing: const Icon(Icons.share, color: Colors.green),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
