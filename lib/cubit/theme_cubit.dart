import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _prefKey = 'is_dark_mode';

  ThemeCubit([ThemeMode? initialMode])
      : super(initialMode ?? _getDeviceThemeMode()) {
    if (initialMode == null) {
      loadTheme();
    }
  }

  static ThemeMode _getDeviceThemeMode() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => state == ThemeMode.dark;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isDark = prefs.getBool(_prefKey) ??
        prefs.getBool('isDarkMode') ??
        (prefs.containsKey('theme_mode')
            ? prefs.getString('theme_mode') == 'dark'
            : null);

    if (isClosed) return;

    if (isDark != null) {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    } else {
      emit(_getDeviceThemeMode());
    }
  }

  Future<void> toggleTheme([bool? isDark]) async {
    final bool willBeDark = isDark ?? (state != ThemeMode.dark);
    final newMode = willBeDark ? ThemeMode.dark : ThemeMode.light;
    if (isClosed) return;
    emit(newMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, willBeDark);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (isClosed) return;
    emit(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, mode == ThemeMode.dark);
  }
}
