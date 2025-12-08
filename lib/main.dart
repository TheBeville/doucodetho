import 'package:doucodetho/cubit/user_info_cubit.dart';
import 'package:doucodetho/cubit/streak_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:doucodetho/locator.dart';
import 'package:doucodetho/view/home_view.dart';
import 'package:doucodetho/view/login_view.dart';
import 'package:doucodetho/view/password_reset_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['API_KEY'] ?? '',
  );
  setupLocator();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

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
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StreakDataCubit(),
          ),
          BlocProvider(
            create: (context) => UserInfoCubit(),
          ),
        ],
        child: StreamBuilder(
          stream: supabase.auth.onAuthStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final session = snapshot.hasData ? snapshot.data!.session : null;

            return session != null ? HomeView() : LoginView();
          },
        ),
      ),
    );
  }
}
