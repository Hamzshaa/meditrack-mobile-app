// lib/config/app_theme.dart (or wherever you define themes)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

// --- Define Main Seed Colors ---
const Color primarySeedColor = Colors.blue; // Example: Your main brand color
const Color secondarySeedColor = Colors.teal; // Example: Accent color

class AppTheme {
  // --- Light Theme Definition ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Enable Material 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      primary: primarySeedColor, // Explicitly define if needed
      secondary: secondarySeedColor, // Explicitly define if needed
      brightness: Brightness.light, // Specify light mode
      // Optional: Customize other colors like surface, background, error etc.
      // surface: Colors.white,
      // background: Colors.grey.shade50,
      // error: Colors.red.shade700,
    ),
    // Apply Google Font to the base text theme
    textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme).copyWith(
      // You can further customize specific text styles here if needed
      // displayLarge: GoogleFonts.merienda(textStyle: ThemeData.light().textTheme.displayLarge, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.lato(
          textStyle: ThemeData.light().textTheme.titleLarge,
          fontWeight: FontWeight.w600),
      // bodyMedium: GoogleFonts.lato(textStyle: ThemeData.light().textTheme.bodyMedium, fontSize: 15),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Slightly more rounded
        borderSide: BorderSide(
            color: Colors.grey.shade400, width: 1.0), // Subtler border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: Colors.grey.shade300, width: 1.0), // Lighter enabled border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: primarySeedColor, width: 1.5), // Use seed color
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade700),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14), // Adjust padding
      filled: true,
      fillColor:
          Colors.grey.shade100.withOpacity(0.7), // Slightly transparent fill
      hintStyle: TextStyle(color: Colors.grey.shade500),
      // Use floating label behavior for better UX
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      // labelStyle: TextStyle(color: Colors.grey.shade700), // Use default or customize
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primarySeedColor, // Use seed color
        foregroundColor: Colors.white, // Use colors based on background
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)), // Match input border
        textStyle: GoogleFonts.lato(
            fontSize: 16, fontWeight: FontWeight.bold), // Apply font
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primarySeedColor, // Use seed color
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)), // Add shape
        textStyle: GoogleFonts.lato(
            fontSize: 14, fontWeight: FontWeight.bold), // Apply font
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primarySeedColor,
        side: BorderSide(color: primarySeedColor),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)), // Match input border
        textStyle: GoogleFonts.lato(
            fontSize: 16, fontWeight: FontWeight.bold), // Apply font
      ),
    ),
    cardTheme: CardTheme(
      elevation: 1.5, // Slightly more elevation
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)), // More rounded
      margin: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 8), // Default margins
      // Let ColorScheme define card color (usually surface)
      // color: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0, // Often looks better with M3 surface tint
      systemOverlayStyle: SystemUiOverlayStyle
          .light, // Ensure status bar icons are visible on primary bg
      backgroundColor:
          primarySeedColor, // Use primary color for default AppBar bg
      foregroundColor: Colors.white, // Use color based on background
      titleTextStyle: GoogleFonts.lato(
        // Apply font
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Ensure contrast
      ),
      iconTheme:
          const IconThemeData(color: Colors.white), // Ensure icons are visible
      actionsIconTheme: const IconThemeData(color: Colors.white),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      // Let ColorScheme define dialog background (usually surface)
      // backgroundColor: Colors.white,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // Use scheme colors for consistency
      // backgroundColor: Colors.blueGrey[800],
      // contentTextStyle: const TextStyle(color: Colors.white),
      elevation: 4,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 0.5, // Thinner divider
      space: 0, // No extra space by default
      indent: 16, // Default indent
      endIndent: 16, // Default end indent
    ),
    // Add other theme properties as needed (floatingActionButtonTheme, bottomNavigationBarTheme, etc.)
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      // Example: customize bottom nav bar
      selectedItemColor: primarySeedColor,
      unselectedItemColor: Colors.grey.shade600,
      backgroundColor: Colors.white, // Or use surface variant etc.
      elevation: 4, // Add some elevation maybe
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
          GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle:
          GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: 12),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondarySeedColor, // Use secondary color for FAB
      foregroundColor: Colors.white, // Adjust based on FAB color
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // --- Dark Theme Definition ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true, // Enable Material 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeedColor, // Use the same seed
      primary: primarySeedColor, // Keep primary consistent if desired
      secondary: secondarySeedColor, // Keep secondary consistent
      brightness: Brightness.dark, // Specify dark mode
      // Optional: Customize dark scheme colors
      // surface: Color(0xFF121212), // Example dark surface
      // background: Color(0xFF1F1F1F), // Example dark background
      // error: Colors.redAccent.shade100,
    ),
    // Apply Google Font to the base dark text theme
    textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme).copyWith(
      // Customize specific dark text styles if needed
      titleLarge: GoogleFonts.lato(
          textStyle: ThemeData.dark().textTheme.titleLarge,
          fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      // Define dark input styles
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: primarySeedColor, width: 1.5), // Use primary accent
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent.shade100),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent.shade100, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.grey.shade800
          .withOpacity(0.5), // Darker, slightly transparent fill
      hintStyle: TextStyle(color: Colors.grey.shade500),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      // labelStyle: TextStyle(color: Colors.grey.shade400),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            primarySeedColor, // Keep primary color for buttons? Or use primaryContainer?
        foregroundColor: Colors.white, // Ensure contrast
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primarySeedColor, // Use primary color for emphasis
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primarySeedColor,
        side: BorderSide(color: primarySeedColor),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      // Use dark surface color from ColorScheme
      // color: Color(0xFF1E1E1E), // Example dark card color
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle
          .dark, // Ensure status bar icons are visible on primary bg
      backgroundColor:
          primarySeedColor, // Keep AppBar primary color? Or use dark surface?
      foregroundColor: Colors.white, // Ensure contrast
      titleTextStyle: GoogleFonts.lato(
        // Apply font
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      // Use dark surface color from ColorScheme
      // backgroundColor: Color(0xFF2A2A2A), // Example dark dialog color
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // Use dark theme appropriate colors
      // backgroundColor: Colors.grey[900],
      // contentTextStyle: const TextStyle(color: Colors.white),
      elevation: 4,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade700, // Darker divider
      thickness: 0.5,
      space: 0,
      indent: 16,
      endIndent: 16,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      // Example: customize dark bottom nav bar
      selectedItemColor: primarySeedColor, // Keep primary highlight?
      unselectedItemColor: Colors.grey.shade400, // Lighter grey for contrast
      // backgroundColor: Color(0xFF212121), // Example dark nav background
      elevation: 4,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
          GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle:
          GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: 12),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondarySeedColor, // Keep secondary color for FAB?
      foregroundColor: Colors.black, // Adjust based on FAB color for contrast
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
