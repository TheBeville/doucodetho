import 'package:doucodetho/cubit/theme_cubit.dart';
import 'package:doucodetho/cubit/user_info_cubit.dart';
import 'package:doucodetho/widget/home_view_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HomeViewDrawer dark mode switch toggles theme', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final themeCubit = ThemeCubit(ThemeMode.light);
    final userInfoCubit = UserInfoCubit();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<UserInfoCubit>.value(value: userInfoCubit),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: HomeViewDrawer(),
          ),
        ),
      ),
    );

    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    Switch switchWidget = tester.widget(switchFinder);
    expect(switchWidget.value, isFalse);

    // Tap the switch to toggle to dark mode
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(themeCubit.state, ThemeMode.dark);

    switchWidget = tester.widget(switchFinder);
    expect(switchWidget.value, isTrue);
    expect(switchWidget.thumbColor?.resolve({WidgetState.selected}),
        Colors.green.shade800);
    expect(switchWidget.trackColor?.resolve({WidgetState.selected}),
        Colors.green.shade200);

    await themeCubit.close();
    await userInfoCubit.close();
  });
}
