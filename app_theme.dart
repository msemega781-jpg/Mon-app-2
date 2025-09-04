import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the gaming application.
class AppTheme {
  AppTheme._();

  // Performance Dark color palette optimized for gaming
  static const Color primaryDark = Color(0xFF1A1A1A);
  static const Color secondaryDark = Color(0xFF2D2D30);
  static const Color accentColor = Color(0xFF00D4FF);
  static const Color successColor = Color(0xFF00FF88);
  static const Color warningColor = Color(0xFFFFB800);
  static const Color errorColor = Color(0xFFFF4757);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color surfaceColor = Color(0xFF252528);
  static const Color borderColor = Color(0xFF404040);

  // Additional semantic colors
  static const Color backgroundPrimary = Color(0xFF1A1A1A);
  static const Color cardColor = Color(0xFF252528);
  static const Color dividerColor = Color(0xFF404040);
  static const Color shadowColor = Color(0x1A000000);

  // Text emphasis colors
  static const Color textHighEmphasis = Color(0xFFFFFFFF);
  static const Color textMediumEmphasis = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0x61FFFFFF);

  /// Dark theme optimized for gaming performance
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: accentColor,
      onPrimary: primaryDark,
      primaryContainer: accentColor.withValues(alpha: 0.2),
      onPrimaryContainer: textPrimary,
      secondary: successColor,
      onSecondary: primaryDark,
      secondaryContainer: successColor.withValues(alpha: 0.2),
      onSecondaryContainer: textPrimary,
      tertiary: warningColor,
      onTertiary: primaryDark,
      tertiaryContainer: warningColor.withValues(alpha: 0.2),
      onTertiaryContainer: textPrimary,
      error: errorColor,
      onError: textPrimary,
      surface: surfaceColor,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderColor,
      outlineVariant: borderColor.withValues(alpha: 0.5),
      shadow: shadowColor,
      scrim: primaryDark,
      inverseSurface: textPrimary,
      onInverseSurface: primaryDark,
      inversePrimary: accentColor,
    ),
    scaffoldBackgroundColor: backgroundPrimary,
    cardColor: cardColor,
    dividerColor: dividerColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2.0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: accentColor,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: primaryDark,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryDark,
        backgroundColor: accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: accentColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    textTheme: _buildTextTheme(),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceColor,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabled,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor.withValues(alpha: 0.3);
        }
        return borderColor;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(primaryDark),
      side: const BorderSide(color: borderColor, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor;
        }
        return borderColor;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentColor,
      linearTrackColor: borderColor,
      circularTrackColor: borderColor,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: accentColor,
      thumbColor: accentColor,
      overlayColor: accentColor.withValues(alpha: 0.2),
      inactiveTrackColor: borderColor,
      valueIndicatorColor: accentColor,
      valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(
        color: primaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: accentColor,
      unselectedLabelColor: textSecondary,
      indicatorColor: accentColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 1),
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceColor,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceColor,
      selectedColor: accentColor.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: borderColor, width: 1),
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: surfaceColor,
      selectedTileColor: accentColor.withValues(alpha: 0.1),
      textColor: textPrimary,
      iconColor: textSecondary,
      selectedColor: accentColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: 24,
    ),
    primaryIconTheme: const IconThemeData(
      color: accentColor,
      size: 24,
    ), dialogTheme: DialogThemeData(backgroundColor: surfaceColor),
  );

  /// Light theme (minimal implementation for fallback)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: accentColor,
      onPrimary: Colors.white,
      primaryContainer: accentColor.withValues(alpha: 0.1),
      onPrimaryContainer: primaryDark,
      secondary: successColor,
      onSecondary: Colors.white,
      secondaryContainer: successColor.withValues(alpha: 0.1),
      onSecondaryContainer: primaryDark,
      tertiary: warningColor,
      onTertiary: Colors.white,
      tertiaryContainer: warningColor.withValues(alpha: 0.1),
      onTertiaryContainer: primaryDark,
      error: errorColor,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: primaryDark,
      onSurfaceVariant: Colors.grey[600]!,
      outline: Colors.grey[400]!,
      outlineVariant: Colors.grey[300]!,
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: primaryDark,
      onInverseSurface: Colors.white,
      inversePrimary: accentColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: _buildTextTheme(isLight: true),
  );

  /// Helper method to build text theme optimized for gaming interfaces
  static TextTheme _buildTextTheme({bool isLight = false}) {
    final Color primaryTextColor = isLight ? primaryDark : textPrimary;
    final Color secondaryTextColor =
        isLight ? Colors.grey[600]! : textSecondary;
    final Color disabledTextColor = isLight ? Colors.grey[400]! : textDisabled;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles for component headers
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles for UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: disabledTextColor,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Data text theme for technical information using JetBrains Mono
  static TextTheme dataTextTheme({bool isLight = false}) {
    final Color primaryTextColor = isLight ? primaryDark : textPrimary;
    final Color secondaryTextColor =
        isLight ? Colors.grey[600]! : textSecondary;

    return TextTheme(
      // Large data displays (FPS counters, main metrics)
      displayLarge: GoogleFonts.jetBrainsMono(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: accentColor,
        letterSpacing: 0,
        height: 1.0,
      ),
      displayMedium: GoogleFonts.jetBrainsMono(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: accentColor,
        letterSpacing: 0,
        height: 1.0,
      ),

      // Medium data displays (latency, temperature)
      headlineMedium: GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.2,
      ),
      headlineSmall: GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.2,
      ),

      // Small data displays (detailed metrics)
      bodyLarge: GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.3,
      ),
      bodyMedium: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        letterSpacing: 0,
        height: 1.3,
      ),
      bodySmall: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        letterSpacing: 0,
        height: 1.3,
      ),

      // Labels for data fields
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        letterSpacing: 0,
        height: 1.3,
      ),
      labelMedium: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0,
        height: 1.3,
      ),
    );
  }
}
