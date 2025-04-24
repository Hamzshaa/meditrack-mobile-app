import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

const String _themePrefKey = 'app_theme_mode';

enum AppThemeMode { light, dark, system }

@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  SharedPreferences _getPrefs() {
    return ref.read(sharedPreferencesProvider).requireValue;
  }

  @override
  ThemeMode build() {
    try {
      final prefs = _getPrefs();
      final savedTheme = prefs.getString(_themePrefKey);
      switch (savedTheme) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    } catch (e) {
      print(
          "Error loading theme preference during build: $e. Defaulting to system.");
      return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;

    state = mode;

    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }

    try {
      final prefs = _getPrefs();
      await prefs.setString(_themePrefKey, themeString);
    } catch (e) {
      print("Error saving theme preference: $e");
    }
  }
}

AppThemeMode themeModeToAppThemeMode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return AppThemeMode.light;
    case ThemeMode.dark:
      return AppThemeMode.dark;
    case ThemeMode.system:
      return AppThemeMode.system;
  }
}

ThemeMode appThemeModeToThemeMode(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
}
