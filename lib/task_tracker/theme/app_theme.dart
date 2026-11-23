import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TaskTracker Academic Planner App Design System
/// Extracted directly from Google Stitch Project: 7523627416489242021
/// Theme: "Paper Planner & Doodle Tracker"
class AppTheme {
  // ---------------------------------------------------------------------------
  // 1. Core Stationery & Surface Tokens
  // ---------------------------------------------------------------------------
  static const Color paperSurface = Color(0xFFF4F0E8); // Soothing, warm natural paper canvas (anti-glare)
  static const Color paperWhite = Color(0xFFFAF7F2); // Soft warm ivory note card
  static const Color paperCard = Color(0xFFEDE8DE); // Subtle secondary card fill
  static const Color surfaceContainer = Color(0xFFEBE5D9);
  static const Color surfaceContainerLow = Color(0xFFF2ECE0);
  static const Color surfaceContainerHigh = Color(0xFFE3DCCE);
  static const Color surfaceContainerHighest = Color(0xFFDDD5C6);
  static const Color surfaceDim = Color(0xFFD6CDC0);
  static const Color surfaceBright = Color(0xFFF8F4EC);

  // Inking & Text Tokens
  static const Color inkColor = Color(0xFF1E1E1E); // Deep felt-tip pen ink border & hard drop shadow
  static const Color textPrimary = Color(0xFF141414); // High-contrast charcoal/black ink text
  static const Color textSecondary = Color(0xFF454035); // Graphite pencil subtitle & caption
  static const Color textOutline = Color(0xFF6E6858); // Ruler hatch ticks, pencil borders, visible placeholders
  static const Color outlineVariant = Color(0xFFCEC6B6); // Ruled paper guidelines & spine rings

  // ---------------------------------------------------------------------------
  // 2. Pastel Sticky Note & Highlighter Tokens
  // ---------------------------------------------------------------------------
  // Primary (Pastel Highlighter Yellow - CTA, Memo, Total Schoolworks)
  static const Color primary = Color(0xFF6D5D2A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color pastelYellow = Color(0xFFFFE9A8); // Primary container
  static const Color pastelYellowDark = Color(0xFF786833);
  static const Color onPrimaryContainer = pastelYellowDark;
  static const Color primaryFixed = Color(0xFFF7E1A1);
  static const Color primaryFixedDim = Color(0xFFDAC587);
  static const Color onPrimaryFixed = Color(0xFF231B00);
  static const Color onPrimaryFixedVariant = Color(0xFF534614);

  // Backward-compatible aliases for existing code
  static const Color primaryColor = primary;
  static const Color primaryLight = primaryFixed;
  static const Color secondaryColor = secondary;
  static const Color accentColor = pastelYellow;

  // Secondary (Pastel Lilac - Active Subjects, Literature, Language)
  static const Color secondary = Color(0xFF615B71);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color pastelLilac = Color(0xFFE5DCF6); // Secondary container
  static const Color pastelLilacDark = Color(0xFF665F75);
  static const Color secondaryFixed = Color(0xFFE7DEF8);
  static const Color secondaryFixedDim = Color(0xFFCBC3DC);
  static const Color onSecondaryFixed = Color(0xFF1D192B);
  static const Color onSecondaryFixedVariant = Color(0xFF494458);

  // Tertiary (Pastel Mint Sage - Done & Checked, Completed Tasks, Science)
  static const Color tertiary = Color(0xFF4A6458);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color pastelMint = Color(0xFFD4F1E2); // Tertiary container
  static const Color pastelMintDark = Color(0xFF556F63);
  static const Color tertiaryFixed = Color(0xFFCCE9DA);
  static const Color tertiaryFixedDim = Color(0xFFB1CDBF);
  static const Color onTertiaryFixed = Color(0xFF062017);
  static const Color onTertiaryFixedVariant = Color(0xFF334C41);

  // Error / Urgent (Pastel Pink - High Priority, Actions, Deadlines)
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color pastelPink = Color(0xFFFFDAD6); // Error container
  static const Color pastelPinkDark = Color(0xFF93000A);

  // STEM / Course Code Accent
  static const Color pastelBlue = Color(0xFFDCEEFF);

  // Inverse Surfaces
  static const Color inverseSurface = Color(0xFF303030);
  static const Color inverseOnSurface = Color(0xFFF3F0EF);
  static const Color inversePrimary = Color(0xFFDAC587);

  // ---------------------------------------------------------------------------
  // 3. Priority & Status Semantic Tokens
  // ---------------------------------------------------------------------------
  static const Color priorityHighBg = Color(0xFFFFDAD6);
  static const Color priorityHighText = Color(0xFFBA1A1A);
  static const Color priorityMediumBg = Color(0xFFFFE9A8);
  static const Color priorityMediumText = Color(0xFF6D5D2A);
  static const Color priorityLowBg = Color(0xFFD4F1E2);
  static const Color priorityLowText = Color(0xFF4A6458);

  // Convenience aliases for existing priority badge
  static const Color priorityHigh = priorityHighText;
  static const Color priorityMedium = priorityMediumText;
  static const Color priorityLow = priorityLowText;

  static const Color statusPending = Color(0xFF6D5D2A);
  static const Color statusInProgress = Color(0xFF615B71);
  static const Color statusCompleted = Color(0xFF4A6458);
  static const Color statusOverdue = Color(0xFFBA1A1A);

  // ---------------------------------------------------------------------------
  // 4. Stitch Border Radii Tokens
  // ---------------------------------------------------------------------------
  static const double radiusSm = 4.0; // 0.25rem
  static const double radiusDefault = 8.0; // 0.5rem
  static const double radiusMd = 12.0; // 0.75rem
  static const double radiusLg = 16.0; // 1.0rem
  static const double radiusXl = 24.0; // 1.5rem
  static const double radiusFull = 999.0;

  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusDefault = BorderRadius.circular(radiusDefault);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // ---------------------------------------------------------------------------
  // 5. Stitch Spacing Tokens
  // ---------------------------------------------------------------------------
  static const double spaceXs = 4.0; // 0.25rem
  static const double spaceSm = 8.0; // 0.5rem
  static const double spaceMd = 16.0; // 1.0rem
  static const double spaceLg = 24.0; // 1.5rem
  static const double spaceXl = 36.0; // 2.25rem
  static const double margin = 20.0; // 1.25rem
  static const double marginMobile = 16.0; // 1.0rem
  static const double gutter = 16.0; // 1.0rem
  static const double gutterMobile = 12.0; // 0.75rem

  // ---------------------------------------------------------------------------
  // 6. Tactile Inking Helpers (Hard-Edge Shadows & Crisp Borders)
  // ---------------------------------------------------------------------------
  /// Signature Stitch hard drop shadow (3px 3px 0px #292929)
  static List<BoxShadow> doodleShadow([double offset = 3.0, Color? shadowColor]) {
    return [
      BoxShadow(
        color: shadowColor ?? inkColor,
        offset: Offset(offset, offset),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ];
  }

  /// Signature Stitch felt-tip ink border (2px solid #292929)
  static Border doodleBorder([double width = 2.0, Color? borderColor]) {
    return Border.all(
      color: borderColor ?? inkColor,
      width: width,
    );
  }

  // ---------------------------------------------------------------------------
  // 7. Typography Configuration via google_fonts
  // Headings: Bricolage Grotesque
  // Body & Labels: Quicksand
  // ---------------------------------------------------------------------------
  static TextTheme _buildTextTheme({required Color textColor, required Color secondaryColor}) {
    return TextTheme(
      // Display / Extra Large Headlines
      displayLarge: GoogleFonts.bricolageGrotesque(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 40 / 34,
        letterSpacing: -0.02 * 34,
        color: textColor,
      ),
      displayMedium: GoogleFonts.bricolageGrotesque(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 32 / 26,
        letterSpacing: -0.02 * 26,
        color: textColor,
      ),
      displaySmall: GoogleFonts.bricolageGrotesque(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 30 / 24,
        letterSpacing: -0.01 * 24,
        color: textColor,
      ),

      // Headlines
      headlineLarge: GoogleFonts.bricolageGrotesque(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 30 / 24,
        letterSpacing: -0.01 * 24,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.bricolageGrotesque(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 26 / 20,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.bricolageGrotesque(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 22 / 17,
        color: textColor,
      ),

      // Titles
      titleLarge: GoogleFonts.quicksand(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 24 / 18,
        color: textColor,
      ),
      titleMedium: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 22 / 16,
        color: textColor,
      ),
      titleSmall: GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: textColor,
      ),

      // Body Text
      bodyLarge: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 24 / 16,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: textColor,
      ),
      bodySmall: GoogleFonts.quicksand(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        color: secondaryColor,
      ),

      // Labels & Badges
      labelLarge: GoogleFonts.quicksand(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        height: 18 / 13,
        letterSpacing: 0.02 * 13,
        color: textColor,
      ),
      labelMedium: GoogleFonts.quicksand(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 14 / 11,
        letterSpacing: 0.04 * 11,
        color: textColor,
      ),
      labelSmall: GoogleFonts.quicksand(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 12 / 10,
        letterSpacing: 0.03 * 10,
        color: secondaryColor,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 8. Material 3 Light ThemeData
  // ---------------------------------------------------------------------------
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: pastelYellow,
      onPrimaryContainer: pastelYellowDark,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: pastelLilac,
      onSecondaryContainer: pastelLilacDark,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: pastelMint,
      onTertiaryContainer: pastelMintDark,
      error: error,
      onError: onError,
      errorContainer: pastelPink,
      onErrorContainer: pastelPinkDark,
      surface: paperSurface,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceContainerHighest,
      onSurfaceVariant: textSecondary,
      outline: textOutline,
      outlineVariant: outlineVariant,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
      surfaceTint: primary,
    );

    final textTheme = _buildTextTheme(
      textColor: textPrimary,
      secondaryColor: textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: paperSurface,
      textTheme: textTheme,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: paperSurface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: inkColor),
      ),

      // Card Theme (Neobrutalist Paper Card)
      cardTheme: CardThemeData(
        color: paperWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLg,
          side: const BorderSide(color: inkColor, width: 2),
        ),
      ),

      // Elevated Button Theme (Highlighter Action Button)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pastelYellow,
          foregroundColor: inkColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusMd,
            side: const BorderSide(color: inkColor, width: 2),
          ),
          textStyle: GoogleFonts.bricolageGrotesque(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: paperWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          side: const BorderSide(color: inkColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusMd,
          ),
          textStyle: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Floating Action Button Theme (Circular Yellow FAB with hard border)
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: pastelYellow,
        foregroundColor: inkColor,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: CircleBorder(
          side: BorderSide(color: inkColor, width: 2.5),
        ),
      ),

      // Text Selection & Cursor Theme (high-visibility dark cursor)
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: inkColor,
        selectionColor: pastelYellow,
        selectionHandleColor: inkColor,
      ),

      // Input Decoration Theme (High-contrast, crisp 2px ink outline)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIconColor: inkColor,
        suffixIconColor: inkColor,
        border: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: inkColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: inkColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: inkColor, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: error, width: 2.5),
        ),
        labelStyle: GoogleFonts.quicksand(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        floatingLabelStyle: GoogleFonts.quicksand(
          color: inkColor,
          fontWeight: FontWeight.w800,
        ),
        hintStyle: GoogleFonts.quicksand(
          color: textOutline,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: GoogleFonts.quicksand(
          color: error,
          fontWeight: FontWeight.w700,
        ),
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: paperSurface.withAlpha(235),
        elevation: 0,
        indicatorColor: pastelYellow,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return GoogleFonts.quicksand(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? primary : textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? primary : textSecondary,
            size: 22,
          );
        }),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: paperWhite,
        selectedColor: pastelYellow,
        disabledColor: surfaceContainer,
        labelStyle: GoogleFonts.quicksand(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        side: const BorderSide(color: inkColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusFull,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return pastelMint;
          }
          return paperWhite;
        }),
        checkColor: WidgetStateProperty.all(inkColor),
        side: const BorderSide(color: inkColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: paperSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLg,
          side: const BorderSide(color: inkColor, width: 2),
        ),
        titleTextStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        contentTextStyle: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: outlineVariant,
        thickness: 1,
        space: 16,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 9. Material 3 Dark / Muted Night Study Mode
  // ---------------------------------------------------------------------------
  static ThemeData get darkTheme {
    const darkBackground = Color(0xFF1E1E1E);
    const darkSurface = Color(0xFF252525);
    const darkSurfaceContainer = Color(0xFF2C2C2C);
    const darkTextPrimary = Color(0xFFF3F0EF);
    const darkTextSecondary = Color(0xFFCEC6B6);
    const darkOutline = Color(0xFF7D7769);

    const darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFDAC587),
      onPrimary: Color(0xFF231B00),
      primaryContainer: Color(0xFF534614),
      onPrimaryContainer: Color(0xFFF7E1A1),
      secondary: Color(0xFFCBC3DC),
      onSecondary: Color(0xFF1D192B),
      secondaryContainer: Color(0xFF494458),
      onSecondaryContainer: Color(0xFFE7DEF8),
      tertiary: Color(0xFFB1CDBF),
      onTertiary: Color(0xFF062017),
      tertiaryContainer: Color(0xFF334C41),
      onTertiaryContainer: Color(0xFFCCE9DA),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: darkSurface,
      onSurface: darkTextPrimary,
      surfaceContainerHighest: darkSurfaceContainer,
      onSurfaceVariant: darkTextSecondary,
      outline: darkOutline,
      outlineVariant: Color(0xFF4B463A),
      inverseSurface: Color(0xFFFCF9F8),
      onInverseSurface: Color(0xFF1B1C1C),
      inversePrimary: primary,
      surfaceTint: Color(0xFFDAC587),
    );

    final textTheme = _buildTextTheme(
      textColor: darkTextPrimary,
      secondaryColor: darkTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: darkTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLg,
          side: const BorderSide(color: darkOutline, width: 1.5),
        ),
      ),
    );
  }
}
