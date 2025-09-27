import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryLightColor = Color(0xFF60AD5E);
  static const Color primaryDarkColor = Color(0xFF005005);
  
  static const Color secondaryColor = Color(0xFF8BC34A);
  static const Color secondaryLightColor = Color(0xFFB2DFDB);
  static const Color secondaryDarkColor = Color(0xFF5D4037);
  
  static const Color accentColor = Color(0xFFFF9800);
  static const Color accentLightColor = Color(0xFFFFB74D);
  static const Color accentDarkColor = Color(0xFFE65100);
  
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);
  
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x1A000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, secondaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [successColor, Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    colors: [errorColor, Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [warningColor, Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text Styles
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static TextStyle get heading4 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static TextStyle get heading5 => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static TextStyle get heading6 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );
  
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );
  
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );
  
  static TextStyle get overline => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.2,
    letterSpacing: 1.5,
  );
  
  // Custom Text Styles
  static TextStyle get appBarTitle => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static TextStyle get cardTitle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static TextStyle get cardSubtitle => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
  
  static TextStyle get listTileTitle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );
  
  static TextStyle get listTileSubtitle => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
  
  static TextStyle get chipLabel => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );
  
  static TextStyle get tabLabel => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );
  
  static TextStyle get dialogTitle => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static TextStyle get dialogContent => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryLightColor,
        secondary: secondaryColor,
        secondaryContainer: secondaryLightColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: appBarTitle,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[100],
        labelStyle: chipLabel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        labelStyle: tabLabel,
        unselectedLabelStyle: tabLabel,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: primaryColor, width: 2),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: dialogTitle,
        contentTextStyle: dialogContent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: listTileTitle,
        subtitleTextStyle: listTileSubtitle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryLightColor,
        primaryContainer: primaryColor,
        secondary: secondaryLightColor,
        secondaryContainer: secondaryColor,
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: errorColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: appBarTitle,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLightColor,
          foregroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLightColor,
          side: const BorderSide(color: primaryLightColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLightColor,
          textStyle: button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryLightColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2C2C2C),
        labelStyle: chipLabel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryLightColor,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: tabLabel,
        unselectedLabelStyle: tabLabel,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: primaryLightColor, width: 2),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: dialogTitle,
        contentTextStyle: dialogContent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: primaryLightColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF404040),
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: listTileTitle,
        subtitleTextStyle: listTileSubtitle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  // Custom Widget Themes
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: shadowColor,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration get primaryCardDecoration => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration get successCardDecoration => BoxDecoration(
    gradient: successGradient,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: successColor.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration get errorCardDecoration => BoxDecoration(
    gradient: errorGradient,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: errorColor.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration get warningCardDecoration => BoxDecoration(
    gradient: warningGradient,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: warningColor.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}