import 'package:doucodetho/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeCubit', () {
    test('initial state defaults to ThemeMode.light when no preference set',
        () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = ThemeCubit();
      expect(cubit.state, ThemeMode.light);
      expect(cubit.isDarkMode, isFalse);
      await cubit.close();
    });

    test('defaults to device brightness when no preference is saved', () async {
      SharedPreferences.setMockInitialValues({});
      TestWidgetsFlutterBinding.instance.platformDispatcher
          .platformBrightnessTestValue = Brightness.dark;

      final cubit = ThemeCubit();
      await cubit.loadTheme();
      expect(cubit.state, ThemeMode.dark);
      expect(cubit.isDarkMode, isTrue);
      await cubit.close();

      TestWidgetsFlutterBinding.instance.platformDispatcher
          .platformBrightnessTestValue = Brightness.light;
    });

    test('initial state uses initialMode if provided', () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = ThemeCubit(ThemeMode.dark);
      expect(cubit.state, ThemeMode.dark);
      expect(cubit.isDarkMode, isTrue);
      await cubit.close();
    });

    test('loads dark mode from SharedPreferences if saved', () async {
      SharedPreferences.setMockInitialValues({'is_dark_mode': true});
      final cubit = ThemeCubit();
      await cubit.loadTheme();
      expect(cubit.state, ThemeMode.dark);
      expect(cubit.isDarkMode, isTrue);
      await cubit.close();
    });

    test('toggleTheme updates state and saves to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = ThemeCubit(ThemeMode.light);

      await cubit.toggleTheme(true);
      expect(cubit.state, ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_dark_mode'), isTrue);

      await cubit.toggleTheme(false);
      expect(cubit.state, ThemeMode.light);
      expect(prefs.getBool('is_dark_mode'), isFalse);

      await cubit.toggleTheme();
      expect(cubit.state, ThemeMode.dark);
      expect(prefs.getBool('is_dark_mode'), isTrue);

      await cubit.close();
    });

    test('setThemeMode updates state and saves to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = ThemeCubit(ThemeMode.light);

      await cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state, ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_dark_mode'), isTrue);

      await cubit.setThemeMode(ThemeMode.light);
      expect(cubit.state, ThemeMode.light);
      expect(prefs.getBool('is_dark_mode'), isFalse);

      await cubit.close();
    });
  });
}
