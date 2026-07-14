import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ArogyaSathi color palette — healthcare-appropriate with good
/// accessibility contrast ratios (WCAG AA+).
class AppColors {
  // Primary — Deep teal (trust, healthcare)
  static const Color primary = Color(0xFF00796B);
  static const Color primaryLight = Color(0xFF48A999);
  static const Color primaryDark = Color(0xFF004C40);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary — Warm amber (urgency / action)
  static const Color secondary = Color(0xFFFF8F00);
  static const Color secondaryLight = Color(0xFFFFBF45);
  static const Color secondaryDark = Color(0xFFC56000);
  static const Color onSecondary = Color(0xFF1A1A1A);

  // Severity colours
  static const Color severityCritical = Color(0xFFD32F2F);
  static const Color severityHigh = Color(0xFFF57C00);
  static const Color severityModerate = Color(0xFFFBC02D);
  static const Color severityLow = Color(0xFF388E3C);

  // Surface / background
  static const Color backgroundLight = Color(0xFFF5F7F6);
  static const Color backgroundDark = Color(0xFF0D1514);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C2826);
  static const Color surfaceVariantLight = Color(0xFFE8F5E9);
  static const Color surfaceVariantDark = Color(0xFF233230);

  // Text
  static const Color textPrimaryLight = Color(0xFF1A2421);
  static const Color textSecondaryLight = Color(0xFF546E6A);
  static const Color textPrimaryDark = Color(0xFFE0F2F1);
  static const Color textSecondaryDark = Color(0xFF80CBC4);

  // Divider / border
  static const Color dividerLight = Color(0xFFCFD8DC);
  static const Color dividerDark = Color(0xFF37474F);

  // Error
  static const Color error = Color(0xFFB71C1C);
  static const Color errorContainer = Color(0xFFFFCDD2);
}

class AppTheme {
  AppTheme._();

  // ─── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryLight,
        onSecondaryContainer: AppColors.secondaryDark,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.error,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.surfaceVariantLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        outline: AppColors.dividerLight,
        outlineVariant: AppColors.dividerLight.withOpacity(0.5),
        scrim: Colors.black54,
        inverseSurface: AppColors.surfaceDark,
        onInverseSurface: AppColors.textPrimaryDark,
        inversePrimary: AppColors.primaryLight,
        shadow: Colors.black12,
        surfaceTint: AppColors.primary,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _buildTextTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.light),
      navigationBarTheme: _buildNavigationBarTheme(Brightness.light),
      cardTheme: _buildCardTheme(AppColors.surfaceLight),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
      chipTheme: _buildChipTheme(Brightness.light),
      dividerTheme: const DividerThemeData(color: AppColors.dividerLight, thickness: 1),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryLight, size: 24),
      floatingActionButtonTheme: _buildFabTheme(),
    );
  }

  // ─── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        onPrimary: AppColors.primaryDark,
        primaryContainer: AppColors.primary,
        onPrimaryContainer: AppColors.onPrimary,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.secondaryDark,
        secondaryContainer: AppColors.secondary,
        onSecondaryContainer: AppColors.onSecondary,
        error: Color(0xFFEF9A9A),
        onError: AppColors.error,
        errorContainer: AppColors.error,
        onErrorContainer: Color(0xFFFFCDD2),
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.surfaceVariantDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        outline: AppColors.dividerDark,
        outlineVariant: AppColors.dividerDark.withOpacity(0.5),
        scrim: Colors.black87,
        inverseSurface: AppColors.surfaceLight,
        onInverseSurface: AppColors.textPrimaryLight,
        inversePrimary: AppColors.primary,
        shadow: Colors.black26,
        surfaceTint: AppColors.primaryLight,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _buildTextTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.dark),
      navigationBarTheme: _buildNavigationBarTheme(Brightness.dark),
      cardTheme: _buildCardTheme(AppColors.surfaceDark),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
      chipTheme: _buildChipTheme(Brightness.dark),
      dividerTheme: const DividerThemeData(color: AppColors.dividerDark, thickness: 1),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark, size: 24),
      floatingActionButtonTheme: _buildFabTheme(),
    );
  }

  // ─── Text Theme ───────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    // Noto Sans supports Latin + Devanagari (Hindi/Marathi)
    return GoogleFonts.notoSansTextTheme(
      TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: primary, letterSpacing: -0.25),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: primary),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: primary),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: primary),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: primary),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: primary),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primary, letterSpacing: 0.15),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary, letterSpacing: 0.1),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primary, letterSpacing: 0.5),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: primary, letterSpacing: 0.25),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: secondary, letterSpacing: 0.4),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primary, letterSpacing: 1.25),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 1.0),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 1.5),
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return AppBarTheme(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: true,
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.15,
      ),
    );
  }

  // ─── Bottom Nav ───────────────────────────────────────────────────────────
  static BottomNavigationBarThemeData _buildBottomNavTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return NavigationBarThemeData(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      indicatorColor: AppColors.primary.withOpacity(0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary, size: 26);
        }
        return IconThemeData(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          size: 24,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.notoSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          );
        }
        return GoogleFonts.notoSans(
          fontSize: 11,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        );
      }),
      elevation: 8,
    );
  }

  // ─── Card ─────────────────────────────────────────────────────────────────
  static CardThemeData _buildCardTheme(Color surface) {
    return CardThemeData(
      color: surface,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    );
  }

  // ─── Elevated Button ──────────────────────────────────────────────────────
  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.notoSans(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    );
  }

  // ─── Outlined Button ──────────────────────────────────────────────────────
  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.notoSans(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    );
  }

  // ─── Input Decoration ─────────────────────────────────────────────────────
  static InputDecorationTheme _buildInputDecorationTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.notoSans(
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        fontSize: 14,
      ),
    );
  }

  // ─── Chip ─────────────────────────────────────────────────────────────────
  static ChipThemeData _buildChipTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ChipThemeData(
      backgroundColor: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // ─── FAB ──────────────────────────────────────────────────────────────────
  static FloatingActionButtonThemeData _buildFabTheme() {
    return const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
      elevation: 6,
    );
  }
}
