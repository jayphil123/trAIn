import 'package:flutter/material.dart';

class AppTheme {
  // Define primary colors
  static const Color primaryColor = Color(0xFF8638E5);
  static const Color secondaryColor = Color(0xFF232323);
  static const Color alternateColor = Color(0xFF262D34);
  static const Color accentColor = Color(0xFFe0e0e0);
  static const Color tertiaryColor = Color(0xFF39d2c0);

  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF8b97a2);
  static const Color tertiaryText = Color(0x00000000);
  // static const Color secondaryText = Color(0xFF8B97A2);
  static const Color primaryBackground = Color(0xFF1A1F24);
  static const Color secondaryBackground = Color(0xFF111417);

  // styles for homepage background colors
  static const Color firstBackground = Color.fromARGB(255, 222, 224, 223);
  static const Color secondBackground = Color.fromARGB(255, 118, 118, 118);

    static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 24);

  // Text style for titles
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryText,
  );


  static const TextStyle subTitleTextStyle = TextStyle(
      fontSize: 24,
      color: primaryText,
    );

  // Text style for body text
  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: primaryText,
  );

  // Define theme data
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryBackground,
        iconTheme: IconThemeData(color: primaryText),
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: titleTextStyle,
        bodyLarge: bodyTextStyle,
        bodyMedium: TextStyle(color: secondaryText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: primaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryBackground,
        hintStyle: TextStyle(color: secondaryText),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(secondaryColor),
        checkColor: WidgetStateProperty.all(primaryText),
        side: BorderSide(color: secondaryText),
      ),
      iconTheme: const IconThemeData(color: primaryText),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: primaryBackground,
        surfaceContainerHighest: alternateColor,
        onPrimary: primaryText,
        onSecondary: secondaryText,
      ),

      // MARGIN PAGE THEME
      // pagePadding: const EdgeInsets.symmetric(horizontal: 32), 
    );
  }
}
