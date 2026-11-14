import 'package:doucodetho/cubit/theme_cubit.dart';
import 'package:doucodetho/cubit/user_info_cubit.dart';
import 'package:doucodetho/widget/home_view_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HomeViewDrawer segmented button updates theme mode',
      (tester) async {
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

    final segmentedButtonFinder = find.byType(SegmentedButton<ThemeMode>);
    expect(segmentedButtonFinder, findsOneWidget);

    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);

    SegmentedButton<ThemeMode> segmentedButton =
        tester.widget(segmentedButtonFinder);
    expect(segmentedButton.selected, {ThemeMode.light});

    // Tap 'Dark' segment
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(themeCubit.state, ThemeMode.dark);
    segmentedButton = tester.widget(segmentedButtonFinder);
    expect(segmentedButton.selected, {ThemeMode.dark});

    // Tap 'System' segment
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();

    expect(themeCubit.state, ThemeMode.system);
    segmentedButton = tester.widget(segmentedButtonFinder);
    expect(segmentedButton.selected, {ThemeMode.system});

    await themeCubit.close();
    await userInfoCubit.close();
  });
}
