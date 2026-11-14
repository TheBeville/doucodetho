import 'package:doucodetho/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeCubit', () {
    test('initial state defaults to ThemeMode.system when no preference set',
        () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = ThemeCubit();
      expect(cubit.state, ThemeMode.system);
      await cubit.close();
    });

    test('initial state uses initialMode if provided', () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = ThemeCubit(ThemeMode.dark);
      expect(cubit.state, ThemeMode.dark);
      expect(cubit.isDarkMode, isTrue);
      await cubit.close();
    });

    test('loads theme_mode from SharedPreferences if saved', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
      final cubit = ThemeCubit();
      await cubit.loadTheme();
      expect(cubit.state, ThemeMode.dark);
      expect(cubit.isDarkMode, isTrue);
      await cubit.close();

      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      final lightCubit = ThemeCubit();
      await lightCubit.loadTheme();
      expect(lightCubit.state, ThemeMode.light);
      expect(lightCubit.isDarkMode, isFalse);
      await lightCubit.close();

      SharedPreferences.setMockInitialValues({'theme_mode': 'system'});
      final systemCubit = ThemeCubit();
      await systemCubit.loadTheme();
      expect(systemCubit.state, ThemeMode.system);
      await systemCubit.close();
    });

    test('falls back to legacy is_dark_mode from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'is_dark_mode': true});
      final cubit = ThemeCubit();
      await cubit.loadTheme();
      expect(cubit.state, ThemeMode.dark);
      expect(cubit.isDarkMode, isTrue);
      await cubit.close();
    });

    test('setThemeMode updates state and saves to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = ThemeCubit(ThemeMode.light);

      await cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state, ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'dark');
      expect(prefs.getBool('is_dark_mode'), isTrue);

      await cubit.setThemeMode(ThemeMode.light);
      expect(cubit.state, ThemeMode.light);
      expect(prefs.getString('theme_mode'), 'light');
      expect(prefs.getBool('is_dark_mode'), isFalse);

      await cubit.setThemeMode(ThemeMode.system);
      expect(cubit.state, ThemeMode.system);
      expect(prefs.getString('theme_mode'), 'system');

      await cubit.close();
    });
  });
}
