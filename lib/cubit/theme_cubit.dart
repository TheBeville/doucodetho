import 'package:doucodetho/home_widget/home_widget_service.dart';
import 'package:doucodetho/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _prefKey = 'theme_mode';
  static const String _legacyPrefKey = 'is_dark_mode';

  ThemeCubit([ThemeMode? initialMode])
      : super(initialMode ?? ThemeMode.system) {
    if (initialMode == null) {
      loadTheme();
    }
  }

  /// Retrieves the saved [ThemeMode] from [SharedPreferences], falling back to
  /// legacy preferences or [ThemeMode.system].
  static Future<ThemeMode> getSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedThemeMode = prefs.getString(_prefKey);

    if (savedThemeMode == 'dark') {
      return ThemeMode.dark;
    } else if (savedThemeMode == 'light') {
      return ThemeMode.light;
    } else if (savedThemeMode == 'system') {
      return ThemeMode.system;
    }

    final bool? isDark =
        prefs.getBool(_legacyPrefKey) ?? prefs.getBool('isDarkMode');
    if (isDark != null) {
      return isDark ? ThemeMode.dark : ThemeMode.light;
    }

    return ThemeMode.system;
  }

  bool get isDarkMode {
    if (state == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }

  Future<void> loadTheme() async {
    final mode = await getSavedThemeMode();
    if (!isClosed) {
      emit(mode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (isClosed) return;
    emit(mode);
    final prefs = await SharedPreferences.getInstance();
    final String modeString = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_prefKey, modeString);
    await prefs.setBool(_legacyPrefKey, mode == ThemeMode.dark);

    await _updateWidget(modeString);
  }

  Future<void> toggleTheme([bool? isDark]) async {
    final bool willBeDark = isDark ?? (state != ThemeMode.dark);
    await setThemeMode(willBeDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _updateWidget(String themeModeString) async {
    if (locator.isRegistered<HomeWidgetService>()) {
      await locator<HomeWidgetService>().updateThemeMode(themeModeString);
    }
  }
}
