import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart'; // تحتاج لإضافة هذه المكتبة في pubspec.yaml
import 'dart:convert';
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
          selectedLabelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 12, fontWeight: FontWeight.w600),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // تحديد التحية حسب الوقت
    var hour = DateTime.now().hour;
    String greeting = hour < 12 ? "صباح الخير" : (hour < 18 ? "مساء الخير" : "مساء الخير");
    String mainAdhkar = hour < 12 ? "أذكار الصباح" : "أذكار المساء";
    IconData mainIcon = hour < 12 ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط علوي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(greeting, style: GoogleFonts.amiri(fontSize: 28, color: colorScheme.primary, fontWeight: FontWeight.bold)),
                CircleAvatar(backgroundColor: colorScheme.secondary.withOpacity(0.2), child: Icon(Icons.mosque, color: colorScheme.secondary)),
              ],
            ),
            const SizedBox(height: 30),
            
            // بطاقة البدء السريع (تتغير تلقائياً)
            Card(
              child: InkWell(
                onTap: () {
                  // الانتقال لتبويب الأذكار وفتح الذكر المناسب (سنضيف هذا لاحقاً)
                },
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
                            Text(mainAdhkar, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text("ابدأ قراءة ${mainAdhkar.toLowerCase()} الآن", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightSubtext)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: colorScheme.primary.withOpacity(0.5)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // قسم "قصة اليوم"
            Text("قصة وفائدة اليوم", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("قصة الأمانة والبركة", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.primary)), // عنوان القصة
                    const SizedBox(height: 10),
                    Text(
                      "يُحكى أن رجلاً صالحاً اشترى أرضاً ووجد فيها كنزاً...\n(مختصر القصة)",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // فتح القصة كاملة في نافذة منبثقة
                        },
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
    // تحميل الأذكار من ملف JSON الذي أضفناه في Assets
    _adhkarFuture = _loadAdhkarJson();
  }

  Future<List<dynamic>> _loadAdhkarJson() async {
    final String response = await rootBundle.loadString('assets/data/adhkar.json');
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
        setState(() => _isPlaying = false);
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
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            // شريط علوي للتبويبات الفرعية (الصباح، المساء، الاستغفار، أخرى)
            TabBar(
              isScrollable: true,
              labelStyle: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 14),
              tabs: const [
                Tab(text: "أذكار الصباح"),
                Tab(text: "أذكار المساء"),
                Tab(text: "الاستغفار والتسبيح"),
                Tab(text: "أدعية وأوراد"),
              ],
            ),
            
            // محتوى التبويبات
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
                    // تصفية البيانات حسب التصنيف (فلترة وهمية، يجب تطبيقها بدقة)
                    final morning = snapshot.data!.where((e) => e['category'] == 'أذكار الصباح').toList();
                    final evening = snapshot.data!.where((e) => e['category'] == 'أذكار المساء').toList();
                    final istighfar = snapshot.data!.where((e) => e['category'] == 'الاستغفار والتسبيح').toList();
                    final general = snapshot.data!.where((e) => e['category'] != 'أذكار الصباح' && e['category'] != 'أذكار المساء' && e['category'] != 'الاستغفار والتسبيح').toList();

                    return TabBarView(
                      children: [
                        _buildAdhkarList(morning, true), // أذكار الصباح مع ميزة الصوت
                        _buildAdhkarList(evening, true), // أذكار المساء مع ميزة الصوت
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
    // رابط صوت العفاسي لأذكار الصباح والمساء (روابط خارجية ثابتة)
    final morningAudioUrl = "https://server8.mp3quran.net/afs/001.mp3"; // هذه تجربة، استخدم الروابط الصحيحة
    final eveningAudioUrl = "https://server8.mp3quran.net/afs/114.mp3"; // هذه تجربة، استخدم الروابط الصحيحة

    return Column(
      children: [
        if (hasAudio)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Card(
              color: colorScheme.secondary.withOpacity(0.1),
              elevation: 0,
              child: ListTile(
                leading: Icon(Icons.headset_mic, color: colorScheme.secondary),
                title: Text("استمع لأذكار ${adhkarList[0]['category'].split(' ').last}", style: TextStyle(color: colorScheme.secondary)),
                subtitle: const Text("بصوت الشيخ مشاري العفاسي"),
                trailing: IconButton(
                  icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: colorScheme.secondary, size: 32),
                  onPressed: () => _playAudio(adhkarList[0]['category'] == 'أذكار الصباح' ? morningAudioUrl : eveningAudioUrl),
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
                        dhikr['text'],
                        style: AppTheme.dhikrTextStyle(context, 1.0), // استخدام خط Amiri الجميل
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("العدد: ${dhikr['count']}", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 10),
                          Flexible(child: Text(dhikr['reward'] ?? '', style: TextStyle(color: AppColors.lightSubtext, fontSize: 12), textAlign: TextAlign.end)),
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
    
    // اهتزاز عند الوصول للهدف (مضاعفات الهدف)
    if (_currentCount > 0 && _currentCount % _targetCount == 0) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 100);
      }
      // تشغيل صوت هادئ (اختياري، يتطلب مكتبة إضافية)
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
    double progress = _targetCount > 0 ? (_currentCount % _targetCount) / _targetCount : 0.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اختيار الذكر
            DropdownButton<String>(
              value: _selectedDhikr,
              isExpanded: true,
              style: GoogleFonts.ibmPlexSansArabic(fontSize: 16, color: colorScheme.onSurface),
              underline: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDhikr = newValue!;
                  _currentCount = 0; // إعادة تعيين العداد عند تغيير الذكر
                  _targetCount = newValue == "أستغفر الله" ? 100 : 33; // تحديد الهدف الافتراضي
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
            
            // العداد الدائري العصري
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
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ),
                  Column(
                    children: [
                      Text(_currentCount.toString().padLeft(2, '0'), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                      Text("من $_targetCount", style: TextStyle(color: AppColors.lightSubtext)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            
            // زر إعادة التعيين
            ElevatedButton.icon(
              onPressed: _resetCount,
              icon: const Icon(Icons.refresh),
              label: const Text("إعادة تعيين"),
              style: ElevatedButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}


// --- تبويب "الإشعارات" (الضوابط والتوقيت) ---
class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  bool _generalNotifications = true;
  bool _morningNotifications = true;
  bool _eveningNotifications = true;
  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  _loadNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _generalNotifications = prefs.getBool('generalNotifications') ?? true;
      _morningNotifications = prefs.getBool('morningNotifications') ?? true;
      _eveningNotifications = prefs.getBool('eveningNotifications') ?? true;
      _morningTime = TimeOfDay(hour: prefs.getInt('morningHour') ?? 8, minute: prefs.getInt('morningMinute') ?? 0);
      _eveningTime = TimeOfDay(hour: prefs.getInt('eveningHour') ?? 17, minute: prefs.getInt('eveningMinute') ?? 0);
    });
  }

  _saveNotificationSetting(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) prefs.setBool(key, value);
    if (value is int) prefs.setInt(key, value);
    // هنا يجب إضافة كود إعادة جدولة الإشعارات الحقيقية عبر flutter_local_notifications
  }

  Future<void> _selectTime(BuildContext context, bool isMorning) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? _morningTime : _eveningTime,
    );
    if (picked != null && picked != (isMorning ? _morningTime : _eveningTime)) {
      setState(() {
        if (isMorning) _morningTime = picked; else _eveningTime = picked;
      });
      _saveNotificationSetting(isMorning ? 'morningHour' : 'eveningHour', picked.hour);
      _saveNotificationSetting(isMorning ? 'morningMinute' : 'eveningMinute', picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text("ضبط التنبيهات", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          
          // الإشعارات العامة
          SwitchListTile(
            title: const Text("تفعيل الإشعارات العامة"),
            value: _generalNotifications,
            onChanged: (bool value) {
              setState(() => _generalNotifications = value);
              _saveNotificationSetting('generalNotifications', value);
            },
          ),
          const Divider(),
          
          // أذكار الصباح
          SwitchListTile(
            title: const Text("تذكير أذكار الصباح"),
            value: _morningNotifications,
            onChanged: (bool value) {
              setState(() => _morningNotifications = value);
              _saveNotificationSetting('morningNotifications', value);
            },
          ),
          ListTile(
            title: const Text("وقت أذكار الصباح"),
            subtitle: Text(_morningTime.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context, true),
          ),
          const Divider(),
          
          // أذكار المساء
          SwitchListTile(
            title: const Text("تذكير أذكار المساء"),
            value: _eveningNotifications,
            onChanged: (bool value) {
              setState(() => _eveningNotifications = value);
              _saveNotificationSetting('eveningNotifications', value);
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

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          Text("المزيد", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          
          // تغيير حجم الخط
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
          
          // الوضع الليلي
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
                DropdownMenuItem(value: ThemeMode.system, child: Text("نظام الهاتف")),
                DropdownMenuItem(value: ThemeMode.light, child: Text("فاتح")),
                DropdownMenuItem(value: ThemeMode.dark, child: Text("داكن")),
              ],
            ),
          ),
          const Divider(),
          
          // زر مشاركة التطبيق
          ListTile(
            title: const Text("مشاركة التطبيق للأجر"),
            subtitle: const Text("انشر رابط التطبيق والدال على الخير كفاعله"),
            trailing: const Icon(Icons.share, color: Colors.green),
            onTap: () {
              // تفعيل المشاركة عبر share_plus (سنضيفها)
            },
          ),
        ],
      ),
    );
  }
}

