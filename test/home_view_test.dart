import 'package:doucodetho/cubit/streak_data_cubit.dart';
import 'package:doucodetho/cubit/theme_cubit.dart';
import 'package:doucodetho/cubit/user_info_cubit.dart';
import 'package:doucodetho/model/streak_data_model.dart';
import 'package:doucodetho/model/user_info_model.dart';
import 'package:doucodetho/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeUserInfoCubit extends Cubit<UserInfo> implements UserInfoCubit {
  FakeUserInfoCubit(super.initialState);

  @override
  Future<void> getUserName({bool isRefresh = false}) async {}

  @override
  Future<void> signOut() async {}
}

class FakeStreakDataCubit extends Cubit<StreakData> implements StreakDataCubit {
  FakeStreakDataCubit(super.initialState);

  @override
  Future getStreakData() async {}

  @override
  Future<void> incrementStreaks() async {}

  @override
  Future<void> undoIncrementStreaks() async {}

  @override
  Future<void> resetCurrentStreak(String userID) async {}

  @override
  Future<int> incrementCurrentStreak(String userID) async => 0;

  @override
  Future<int> incrementLongestStreak(String userID) async => 0;

  @override
  Map<String, String> getDates() => {
        'today': '2026-11-01',
        'yesterday': '2026-10-31',
      };

  @override
  Future<void> resetStreakData(String userID) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeUserInfoCubit userInfoCubit;
  late FakeStreakDataCubit streakDataCubit;
  late ThemeCubit themeCubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    themeCubit = ThemeCubit(ThemeMode.light);
    streakDataCubit = FakeStreakDataCubit(
      StreakData(
        current: 0,
        longest: 0,
        dayCompleted: false,
        lastUpdated: DateTime.now(),
      ),
    );
  });

  tearDown(() async {
    await userInfoCubit.close();
    await streakDataCubit.close();
    await themeCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: themeCubit),
        BlocProvider<StreakDataCubit>.value(value: streakDataCubit),
        BlocProvider<UserInfoCubit>.value(value: userInfoCubit),
      ],
      child: const MaterialApp(
        home: HomeView(),
      ),
    );
  }

  testWidgets(
      'displays loading overlay and hides Hello greeting when user info is loading',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    userInfoCubit = FakeUserInfoCubit(
      UserInfo(
        userID: 'user123',
        username: '',
        isLoading: true,
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Verify "Hello, !" is NOT displayed
    expect(find.text('Hello, !'), findsNothing);

    // Verify loading overlay is shown with indicator and message
    expect(find.text('Loading user info...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Check Visibility widget for the greeting has visible == false
    final visibilityFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Visibility &&
          widget.child is Text &&
          ((widget.child as Text).data?.startsWith('Hello') ?? false),
    );
    expect(visibilityFinder, findsOneWidget);
    final Visibility visibilityWidget = tester.widget(visibilityFinder);
    expect(visibilityWidget.visible, isFalse);
  });

  testWidgets(
      'hides loading overlay and shows Hello, <username>! when user info is loaded',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    userInfoCubit = FakeUserInfoCubit(
      UserInfo(
        userID: 'user123',
        username: 'Steve',
        isLoading: false,
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Verify loading overlay is NOT shown
    expect(find.text('Loading user info...'), findsNothing);

    // Verify "Hello, Steve!" is displayed
    expect(find.text('Hello, Steve!'), findsOneWidget);

    // Check Visibility widget has visible == true
    final visibilityFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Visibility &&
          widget.child is Text &&
          ((widget.child as Text).data?.startsWith('Hello') ?? false),
    );
    expect(visibilityFinder, findsOneWidget);
    final Visibility visibilityWidget = tester.widget(visibilityFinder);
    expect(visibilityWidget.visible, isTrue);
  });

  testWidgets('transitions from loading to loaded state properly updating UI',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    userInfoCubit = FakeUserInfoCubit(
      UserInfo(
        userID: 'user123',
        username: '',
        isLoading: true,
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Loading user info...'), findsOneWidget);
    expect(find.text('Hello, !'), findsNothing);

    // Simulate completion of loading
    userInfoCubit.emit(
      UserInfo(
        userID: 'user123',
        username: 'Beville',
        isLoading: false,
      ),
    );
    await tester.pump();

    expect(find.text('Loading user info...'), findsNothing);
    expect(find.text('Hello, Beville!'), findsOneWidget);
  });

  testWidgets('does not show Hello, ! when username is empty after loading',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    userInfoCubit = FakeUserInfoCubit(
      UserInfo(
        userID: 'user123',
        username: '',
        isLoading: false,
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Loading user info...'), findsNothing);
    expect(find.text('Hello, !'), findsNothing);
    expect(find.text('Hello!'), findsOneWidget);
  });
}
