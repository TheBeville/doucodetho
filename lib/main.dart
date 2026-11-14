import 'package:doucodetho/cubit/theme_cubit.dart';
import 'package:doucodetho/cubit/user_info_cubit.dart';
import 'package:doucodetho/cubit/streak_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:doucodetho/locator.dart';
import 'package:doucodetho/view/home_view.dart';
import 'package:doucodetho/view/login_view.dart';
import 'package:doucodetho/view/password_reset_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['API_KEY'] ?? '',
  );
  setupLocator();
  final prefs = await SharedPreferences.getInstance();
  final String? savedThemeMode = prefs.getString('theme_mode');
  final ThemeMode initialThemeMode;
  if (savedThemeMode == 'dark') {
    initialThemeMode = ThemeMode.dark;
  } else if (savedThemeMode == 'light') {
    initialThemeMode = ThemeMode.light;
  } else if (savedThemeMode == 'system') {
    initialThemeMode = ThemeMode.system;
  } else {
    final bool? savedIsDark =
        prefs.getBool('is_dark_mode') ?? prefs.getBool('isDarkMode');
    if (savedIsDark != null) {
      initialThemeMode = savedIsDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      initialThemeMode = ThemeMode.system;
    }
  }

  runApp(MainApp(
    initialThemeMode: initialThemeMode,
  ));
}

class MainApp extends StatefulWidget {
  final ThemeMode? initialThemeMode;

  const MainApp({super.key, this.initialThemeMode});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final supabase = Supabase.instance.client;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    // Listen for deep link auth events (password reset)
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        _navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const PasswordResetView(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(widget.initialThemeMode),
        ),
        BlocProvider(
          create: (context) => StreakDataCubit(),
        ),
        BlocProvider(
          create: (context) => UserInfoCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: StreamBuilder(
              stream: supabase.auth.onAuthStateChange,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final session =
                    snapshot.hasData ? snapshot.data!.session : null;

                return session != null ? HomeView() : LoginView();
              },
            ),
          );
        },
      ),
    );
  }
}
