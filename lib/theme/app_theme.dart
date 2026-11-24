import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // الوضع النهاري: ورق كريمي دافئ + أخضر زمردي + ذهبي هادئ
  static const lightBg = Color(0xFFFBF9F5);
  static const lightCard = Color(0xFFFFFFFF);
  static const primaryEmerald = Color(0xFF146C43);
  static const softEmerald = Color(0xFFE8F3ED);
  static const warmGold = Color(0xFFC59B27);
  static const lightText = Color(0xFF1B2420);
  static const lightSubtext = Color(0xFF5C6B64);

  // الوضع الليلي: كحلي فحمي مريح للعين
  static const darkBg = Color(0xFF0F172A);
  static const darkCard = Color(0xFF1E293B);
  static const darkPrimary = Color(0xFF2DD4BF);
  static const darkGold = Color(0xFFEAB308);
  static const darkText = Color(0xFFF1F5F9);
  static const darkSubtext = Color(0xFF94A3B8);
}

class AppTheme {
  static ThemeData lightTheme(double fontScale) {
    final baseText = GoogleFonts.ibmPlexSansArabicTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryEmerald,
        brightness: Brightness.light,
        primary: AppColors.primaryEmerald,
        secondary: AppColors.warmGold,
        surface: AppColors.lightCard,
      ),
      cardTheme: CardTheme(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black.withOpacity(0.05)),
        ),
      ),
      textTheme: baseText.apply(
        bodyColor: AppColors.lightText,
        displayColor: AppColors.lightText,
        fontSizeFactor: fontScale,
      ),
    );
  }

  static ThemeData darkTheme(double fontScale) {
    final baseText = GoogleFonts.ibmPlexSansArabicTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkPrimary,
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkGold,
        surface: AppColors.darkCard,
      ),
      cardTheme: CardTheme(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      textTheme: baseText.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
        fontSizeFactor: fontScale,
      ),
    );
  }

  static TextStyle dhikrTextStyle(BuildContext context, double fontScale) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.amiri(
      fontSize: 24 * fontScale,
      height: 1.85,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.darkText : AppColors.lightText,
    );
  }
}
