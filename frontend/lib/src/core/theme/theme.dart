// Created with the Assistance of Claude Code
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'breakpoints.dart';
export 'page_alignment.dart';
import 'breakpoints.dart';
import 'page_alignment.dart';

/// Flutter ThemeExtension carrying all app-specific adaptive colours.
/// Accessed via [BuildContext.appColors].
///
/// Chrome colours (backgroundChrome, chromeSurfaceGradient, etc.) intentionally
/// stay in [AppTheme] static getters because they depend on chromeStyle AND
/// themeMode simultaneously and are only used by chrome/header/sidebar widgets.
class AppColorTheme extends ThemeExtension<AppColorTheme> {
  const AppColorTheme({
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSubtle,
    required this.divider,
    required this.textPrimary,
    required this.textMuted,
    required this.chartGrid,
    required this.cardShadow,
    required this.inputFill,
    required this.inputBorder,
    required this.inputBorderFocused,
    required this.rowAlt,
  });

  final Color surface;
  final Color surfaceRaised;
  final Color surfaceSubtle;
  final Color divider;
  final Color textPrimary;
  final Color textMuted;
  final Color chartGrid;
  final List<BoxShadow> cardShadow;
  final Color inputFill;
  final Color inputBorder;
  final Color inputBorderFocused;
  final Color rowAlt; // alternating table row background

  static const AppColorTheme light = AppColorTheme(
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceSubtle: Color(0xFFF8FAFC),
    divider: Color(0xFFE5E7EB),
    textPrimary: Color(0xFF000000),
    textMuted: Color(0xFF5E6773),
    chartGrid: Color(0xFFE5E7EB),
    cardShadow: [
      BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
      BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
    ],
    inputFill: Color(0xFFFFFFFF),
    inputBorder: Color(0xFF6B7280), // ≥3:1 against white — WCAG 1.4.11
    inputBorderFocused: Color(0xFF22446D),
    rowAlt: Color(0xFFF8FAFC),
  );

  static const AppColorTheme dark = AppColorTheme(
    surface: Color(0xFF161D26),
    surfaceRaised: Color(0xFF1C2430),
    surfaceSubtle: Color(0xFF111821),
    divider: Color(0xFF2A3442),
    textPrimary: Color(0xFFF4F7FB),
    textMuted: Color(0xFF98A4B3),
    chartGrid: Color(0xFF3A4556),
    cardShadow: [
      BoxShadow(color: Color(0x3D000000), blurRadius: 12, offset: Offset(0, 4)),
      BoxShadow(color: Color(0x1F000000), blurRadius: 4, offset: Offset(0, 1)),
    ],
    inputFill: Color(0xFF1C2430),
    inputBorder: Color(0xFF8496B0), // ≥3:1 against dark fill — WCAG 1.4.11
    inputBorderFocused: Color(0xFF5B8AC5),
    rowAlt: Color(0xFF111821),
  );

  @override
  AppColorTheme copyWith({
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceSubtle,
    Color? divider,
    Color? textPrimary,
    Color? textMuted,
    Color? chartGrid,
    List<BoxShadow>? cardShadow,
    Color? inputFill,
    Color? inputBorder,
    Color? inputBorderFocused,
    Color? rowAlt,
  }) {
    return AppColorTheme(
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      chartGrid: chartGrid ?? this.chartGrid,
      cardShadow: cardShadow ?? this.cardShadow,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      inputBorderFocused: inputBorderFocused ?? this.inputBorderFocused,
      rowAlt: rowAlt ?? this.rowAlt,
    );
  }

  @override
  AppColorTheme lerp(AppColorTheme? other, double t) {
    if (other is! AppColorTheme) return this;
    return AppColorTheme(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      chartGrid: Color.lerp(chartGrid, other.chartGrid, t)!,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputBorderFocused: Color.lerp(inputBorderFocused, other.inputBorderFocused, t)!,
      rowAlt: Color.lerp(rowAlt, other.rowAlt, t)!,
    );
  }
}

/// Convenience accessor — [Theme.of(context).appColors].
extension AppColorThemeExt on BuildContext {
  AppColorTheme get appColors =>
      Theme.of(this).extension<AppColorTheme>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppColorTheme.dark
          : AppColorTheme.light);
}

enum ChromeStyle {
  classic,
  modern,
  flat,
}

enum AppThemeMode {
  light,
  dark,
}

enum AppThemePreset {
  classicCream,
  classicGrey,
  modern,
  dark,
}

class AppAppearance {
  const AppAppearance({
    this.chromeStyle = ChromeStyle.flat,
    this.themeMode = AppThemeMode.light,
  });

  final ChromeStyle chromeStyle;
  final AppThemeMode themeMode;

  AppAppearance copyWith({
    ChromeStyle? chromeStyle,
    AppThemeMode? themeMode,
  }) {
    return AppAppearance(
      chromeStyle: chromeStyle ?? this.chromeStyle,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppAppearance &&
        other.chromeStyle == chromeStyle &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => Object.hash(chromeStyle, themeMode);
}

class AppTheme {
  // ------------------
  // MAIN COLOURS (from Figma styles.png)
  // ------------------
  static const Color primary = Color(0xFF22446D);
  static const Color primaryHover = Color(0xFF1C3666);
  static const Color secondary = Color(0xFF145B2C);
  static const Color secondaryHover = Color(0xFF0F1A38);
  static const Color muted = Color(0xFF5E6773);
  static const Color mutedHover = Color(0xFF4E5467);

  // ------------------
  // TEXT COLOURS
  // ------------------
  static const Color textPrimary = Color(0xFF000000);
  static const Color textContrast = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF5E6773);
  static Color get adaptiveTextPrimary => isDarkMode
      ? const Color(0xFFF4F7FB)
      : textPrimary;
  static Color get adaptiveTextMuted => isDarkMode
      ? const Color(0xFF98A4B3)
      : textMuted;

  // ------------------
  // BACKGROUND
  // ------------------
  static const Color backgroundMuted = Color(0xFFFAFAFA);
  static Color get surface => isDarkMode
      ? const Color(0xFF161D26)
      : const Color(0xFFFFFFFF);
  static Color get surfaceRaised => isDarkMode
      ? const Color(0xFF1C2430)
      : const Color(0xFFFFFFFF);
  static Color get surfaceSubtle => isDarkMode
      ? const Color(0xFF111821)
      : const Color(0xFFF8FAFC);
  static Color get divider => isDarkMode
      ? const Color(0xFF2A3442)
      : const Color(0xFFE5E7EB);
  static Color get chartGrid => isDarkMode
      ? const Color(0xFF3A4556)
      : const Color(0xFFE5E7EB);
  static List<BoxShadow> get cardShadow => isDarkMode
      ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ];

  static AppAppearance _appearance = const AppAppearance();

  static AppAppearance get appearance => _appearance;
  static ChromeStyle get chromeStyle => _appearance.chromeStyle;
  static AppThemeMode get themeMode => _appearance.themeMode;
  static bool get isDarkMode => _appearance.themeMode == AppThemeMode.dark;

  static void setAppearance(AppAppearance appearance) {
    _appearance = appearance;
  }

  static void setChromeStyle(ChromeStyle style) {
    _appearance = _appearance.copyWith(chromeStyle: style);
  }

  static void setThemeMode(AppThemeMode mode) {
    _appearance = _appearance.copyWith(themeMode: mode);
  }

  static Color get backgroundChrome => switch ((chromeStyle, themeMode)) {
        (ChromeStyle.classic, AppThemeMode.light) => const Color(0xFFF5F0E6),
        (ChromeStyle.classic, AppThemeMode.dark) => const Color(0xFF241F18),
        (ChromeStyle.modern, AppThemeMode.light) => const Color(0xFFF2F4F7),
        (ChromeStyle.modern, AppThemeMode.dark) => const Color(0xFF1B2330),
        (ChromeStyle.flat, AppThemeMode.light) => const Color(0xFFF5F7FA),
        (ChromeStyle.flat, AppThemeMode.dark) => const Color(0xFF151B24),
      };

  static Color get chromeTop => switch ((chromeStyle, themeMode)) {
        (ChromeStyle.classic, AppThemeMode.light) => const Color(0xFFFCFAF4),
        (ChromeStyle.classic, AppThemeMode.dark) => const Color(0xFF342D24),
        (ChromeStyle.modern, AppThemeMode.light) => const Color(0xFFFBFCFE),
        (ChromeStyle.modern, AppThemeMode.dark) => const Color(0xFF293445),
        (ChromeStyle.flat, AppThemeMode.light) => const Color(0xFFF5F7FA),
        (ChromeStyle.flat, AppThemeMode.dark) => const Color(0xFF151B24),
      };

  static Color get chromeBottom => switch ((chromeStyle, themeMode)) {
        (ChromeStyle.classic, AppThemeMode.light) => const Color(0xFFEAE1D2),
        (ChromeStyle.classic, AppThemeMode.dark) => const Color(0xFF17120D),
        (ChromeStyle.modern, AppThemeMode.light) => const Color(0xFFE0E6EF),
        (ChromeStyle.modern, AppThemeMode.dark) => const Color(0xFF111923),
        (ChromeStyle.flat, AppThemeMode.light) => const Color(0xFFF5F7FA),
        (ChromeStyle.flat, AppThemeMode.dark) => const Color(0xFF151B24),
      };

  static Color get chromeBorder => switch ((chromeStyle, themeMode)) {
        (ChromeStyle.classic, AppThemeMode.light) => const Color(0xFFD7CCBA),
        (ChromeStyle.classic, AppThemeMode.dark) => const Color(0xFF4D4337),
        (ChromeStyle.modern, AppThemeMode.light) => const Color(0xFFC7D1DD),
        (ChromeStyle.modern, AppThemeMode.dark) => const Color(0xFF364355),
        (ChromeStyle.flat, AppThemeMode.light) => const Color(0xFFD9E0E8),
        (ChromeStyle.flat, AppThemeMode.dark) => const Color(0xFF2D3846),
      };

  static Color get chromeHighlight => switch ((chromeStyle, themeMode)) {
        (ChromeStyle.classic, AppThemeMode.light) => const Color(0xFFFFFCF6),
        (ChromeStyle.classic, AppThemeMode.dark) => const Color(0xFF3E362C),
        (ChromeStyle.modern, AppThemeMode.light) => const Color(0xFFFFFFFF),
        (ChromeStyle.modern, AppThemeMode.dark) => const Color(0xFF324055),
        (ChromeStyle.flat, AppThemeMode.light) => const Color(0xFFF5F7FA),
        (ChromeStyle.flat, AppThemeMode.dark) => const Color(0xFF151B24),
      };

  static Color get chromeButton => switch ((chromeStyle, themeMode)) {
        (ChromeStyle.classic, AppThemeMode.light) => const Color(0xFFF8F3E9),
        (ChromeStyle.classic, AppThemeMode.dark) => const Color(0xFF2B241C),
        (ChromeStyle.modern, AppThemeMode.light) => const Color(0xFFF5F7FA),
        (ChromeStyle.modern, AppThemeMode.dark) => const Color(0xFF202938),
        (ChromeStyle.flat, AppThemeMode.light) => const Color(0xFFFFFFFF),
        (ChromeStyle.flat, AppThemeMode.dark) => const Color(0xFF1A212D),
      };

  static Color get chromeButtonHover => switch ((chromeStyle, themeMode)) {
        (ChromeStyle.classic, AppThemeMode.light) => const Color(0xFFF0E7D9),
        (ChromeStyle.classic, AppThemeMode.dark) => const Color(0xFF393026),
        (ChromeStyle.modern, AppThemeMode.light) => const Color(0xFFE9EEF5),
        (ChromeStyle.modern, AppThemeMode.dark) => const Color(0xFF293346),
        (ChromeStyle.flat, AppThemeMode.light) => const Color(0xFFEFF3F7),
        (ChromeStyle.flat, AppThemeMode.dark) => const Color(0xFF243041),
      };

  static Gradient get chromeSurfaceGradient {
    if (chromeStyle == ChromeStyle.flat) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          backgroundChrome,
          backgroundChrome,
        ],
      );
    }

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        chromeTop,
        backgroundChrome,
        chromeBottom,
      ],
    );
  }

  static Gradient get chromeSidebarGradient {
    if (chromeStyle == ChromeStyle.flat) {
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          backgroundChrome,
          backgroundChrome,
        ],
      );
    }

    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        chromeBottom,
        backgroundChrome,
        chromeBottom,
      ],
    );
  }

  static Gradient get chromeRailGradient {
    if (chromeStyle == ChromeStyle.flat) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          backgroundChrome,
          backgroundChrome,
          backgroundChrome,
          backgroundChrome,
          backgroundChrome,
        ],
      );
    }

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        chromeTop,
        backgroundChrome,
        chromeBottom,
        backgroundChrome,
        chromeBottom,
      ],
    );
  }

  static Gradient chromeItemGradient({required bool hovered}) {
    if (chromeStyle == ChromeStyle.flat) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          hovered ? chromeButtonHover : chromeButton,
          hovered ? chromeButtonHover : chromeButton,
        ],
      );
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: hovered
          ? [
              chromeTop,
              chromeButtonHover,
            ]
          : [
              chromeTop,
              chromeButton,
            ],
    );
  }

  static List<BoxShadow> get chromeHeaderShadow {
    if (chromeStyle == ChromeStyle.flat) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDarkMode ? 0.22 : 0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
    }

    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.55),
        blurRadius: 0,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static List<BoxShadow> get chromeSidebarShadow {
    if (chromeStyle == ChromeStyle.flat) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDarkMode ? 0.18 : 0.05),
          blurRadius: 8,
          offset: const Offset(2, 0),
        ),
      ];
    }

    return const [
      BoxShadow(
        color: Color(0x16000000),
        blurRadius: 12,
        offset: Offset(3, 0),
      ),
    ];
  }

  static List<BoxShadow> chromeItemShadows({
    required bool active,
    required bool hovered,
  }) {
    if (chromeStyle == ChromeStyle.flat) {
      return [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: active
                ? (isDarkMode ? 0.24 : 0.10)
                : (hovered ? 0.08 : 0.04),
          ),
          blurRadius: active ? 8 : 4,
          offset: const Offset(0, 1),
        ),
      ];
    }

    return [
      if (!active)
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.9),
          blurRadius: 0,
          spreadRadius: -1,
          offset: const Offset(-1, -1),
        ),
      if (!active)
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.8),
          blurRadius: 0,
          offset: const Offset(-1, -1),
        ),
      BoxShadow(
        color: Colors.black.withValues(
          alpha: active ? 0.18 : (hovered ? 0.10 : 0.08),
        ),
        blurRadius: active ? 10 : 8,
        offset: const Offset(0, 3),
      ),
      BoxShadow(
        color: active
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.04),
        blurRadius: 0,
        spreadRadius: -2,
        offset: const Offset(1, 1),
      ),
    ];
  }

  // ------------------
  // SEMANTICS
  // ------------------
  static const Color error = Color(0xFFA6192E);
  static const Color caution = Color(0xFFFF9900);
  static const Color success = Color(0xFF04B34F);
  static const Color info = Color(0xFF0057B8);

  // ------------------
  // CHART EXTRA COLOURS
  // ------------------
  static const Color chartExtra1 = Color(0xFF8E44AD); // purple
  static const Color chartExtra2 = Color(0xFF2C3E50); // navy

  // ------------------
  // OTHER COLOURS
  // ------------------
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteHover = Color(0xFFE9E9E9);
  static const Color gray = Color(0xFFEFEFEF);
  static const Color placeholder = Color(0xFFA9BAFF);

  // ------------------
  // Text (Roboto)
  // ------------------
  static TextStyle get logo =>
      GoogleFonts.roboto(fontSize: 40, fontWeight: FontWeight.bold);

  static TextStyle get heading1 => GoogleFonts.roboto(fontSize: 48);

  static TextStyle get heading2 => GoogleFonts.roboto(fontSize: 40);

  static TextStyle get heading3 => GoogleFonts.roboto(fontSize: 32);

  static TextStyle get heading4 => GoogleFonts.roboto(fontSize: 26);

  static TextStyle get heading5 => GoogleFonts.roboto(fontSize: 22);

  static TextStyle get body => GoogleFonts.roboto(fontSize: 18);

  static TextStyle get captions => GoogleFonts.roboto(fontSize: 16);

  // ------------------
  // RESPONSIVE TYPOGRAPHY
  // ------------------

  /// Returns a TextTheme with font sizes appropriate for the given breakpoint.
  static TextTheme textThemeForBreakpoint(Breakpoint bp) {
    final (h1, h2, h3, h4, h5, bodySize, captionSize) = switch (bp) {
      Breakpoint.compact => (34.0, 28.0, 22.0, 18.0, 16.0, 14.0, 12.0),
      Breakpoint.medium => (38.0, 30.0, 24.0, 20.0, 18.0, 16.0, 14.0),
      Breakpoint.expanded => (48.0, 40.0, 32.0, 26.0, 22.0, 18.0, 16.0),
    };

    return TextTheme(
      displayLarge: GoogleFonts.roboto(
        fontSize: h1,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: h2,
        fontWeight: FontWeight.w700,
        height: 1.18,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: h3,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: h4,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: h5,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      bodyLarge: GoogleFonts.roboto(fontSize: bodySize, height: 1.5),
      bodyMedium: GoogleFonts.roboto(fontSize: bodySize, height: 1.5),
      bodySmall: GoogleFonts.roboto(fontSize: captionSize, height: 1.35),
    );
  }

  /// Returns a full ThemeData configured for the given breakpoint.
  static ThemeData themeForBreakpoint(Breakpoint bp, {AppThemeMode? mode}) {
    final effectiveMode = mode ?? themeMode;
    final isDark = effectiveMode == AppThemeMode.dark;
    final textTheme = textThemeForBreakpoint(bp);

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F141B)
          : const Color(0xFFFAFAFA),
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: textContrast,
        secondary: secondary,
        onSecondary: textContrast,
        error: error,
        onError: textContrast,
        surface: isDark
            ? const Color(0xFF161D26)
            : const Color(0xFFFFFFFF),
        onSurface: isDark
            ? const Color(0xFFF4F7FB)
            : const Color(0xFF000000),
      ),
      // WCAG 2.4.7 — visible focus ring for keyboard navigation
      focusColor: primary.withValues(alpha: 0.18),
      hoverColor: primary.withValues(alpha: 0.06),
      highlightColor: primary.withValues(alpha: 0.10),
      dividerColor: isDark
          ? const Color(0xFF2A3442)
          : const Color(0xFFE5E7EB),
      textTheme: textTheme.apply(
        bodyColor: isDark
            ? const Color(0xFFF4F7FB)
            : const Color(0xFF000000),
        displayColor: isDark
            ? const Color(0xFFF4F7FB)
            : const Color(0xFF000000),
      ),
      cardColor: isDark
          ? const Color(0xFF161D26)
          : const Color(0xFFFFFFFF),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: textContrast,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: textTheme.headlineSmall?.fontSize ?? 22,
          fontWeight: FontWeight.w500,
          color: textContrast,
        ),
      ),
      // WCAG 2.4.7 — global focus overlay on all Material buttons so keyboard
      // focus is clearly visible. overlayColor resolves per WidgetState.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.focused)) {
              return primary.withValues(alpha: 0.18);
            }
            return null;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.focused)) {
              return primary.withValues(alpha: 0.18);
            }
            return null;
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.focused)) {
              return primary.withValues(alpha: 0.18);
            }
            return null;
          }),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppPageAlignmentTheme.forBreakpoint(bp),
        isDark ? AppColorTheme.dark : AppColorTheme.light,
      ],
    );
  }

  // ------------------
  // THEME DATA (backwards compatible - uses expanded breakpoint)
  // ------------------
  static ThemeData get defaultTheme => themeForBreakpoint(Breakpoint.expanded);

  static String chromeStyleLabel(ChromeStyle style) {
    switch (style) {
      case ChromeStyle.classic:
        return 'Classic Cream';
      case ChromeStyle.modern:
        return 'Classic Grey';
      case ChromeStyle.flat:
        return 'Modern';
    }
  }

  static String chromeStyleDescription(ChromeStyle style) {
    switch (style) {
      case ChromeStyle.classic:
        return 'Warm ivory with subtle bevels';
      case ChromeStyle.modern:
        return 'Cool grey chrome with restrained depth';
      case ChromeStyle.flat:
        return 'Clean flat surfaces with minimal separation';
    }
  }

  static String themeModeLabel(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  static AppThemePreset presetForAppearance(AppAppearance appearance) {
    final normalized = appearance.themeMode == AppThemeMode.dark
        ? const AppAppearance(
            chromeStyle: ChromeStyle.flat,
            themeMode: AppThemeMode.dark,
          )
        : appearance;

    switch ((normalized.chromeStyle, normalized.themeMode)) {
      case (ChromeStyle.classic, AppThemeMode.light):
        return AppThemePreset.classicCream;
      case (ChromeStyle.modern, AppThemeMode.light):
        return AppThemePreset.classicGrey;
      case (ChromeStyle.flat, AppThemeMode.light):
        return AppThemePreset.modern;
      case (_, AppThemeMode.dark):
        return AppThemePreset.dark;
    }
  }

  static AppAppearance appearanceForPreset(AppThemePreset preset) {
    switch (preset) {
      case AppThemePreset.classicCream:
        return const AppAppearance(
          chromeStyle: ChromeStyle.classic,
          themeMode: AppThemeMode.light,
        );
      case AppThemePreset.classicGrey:
        return const AppAppearance(
          chromeStyle: ChromeStyle.modern,
          themeMode: AppThemeMode.light,
        );
      case AppThemePreset.modern:
        return const AppAppearance(
          chromeStyle: ChromeStyle.flat,
          themeMode: AppThemeMode.light,
        );
      case AppThemePreset.dark:
        return const AppAppearance(
          chromeStyle: ChromeStyle.flat,
          themeMode: AppThemeMode.dark,
        );
    }
  }

  static String presetLabel(AppThemePreset preset) {
    switch (preset) {
      case AppThemePreset.classicCream:
        return 'Classic Cream';
      case AppThemePreset.classicGrey:
        return 'Classic Grey';
      case AppThemePreset.modern:
        return 'Modern';
      case AppThemePreset.dark:
        return 'Dark';
    }
  }

  static String presetDescription(AppThemePreset preset) {
    switch (preset) {
      case AppThemePreset.classicCream:
        return 'Warm ivory chrome';
      case AppThemePreset.classicGrey:
        return 'Cool grey chrome';
      case AppThemePreset.modern:
        return 'Clean flat light';
      case AppThemePreset.dark:
        return 'Modern dark mode';
    }
  }
}
