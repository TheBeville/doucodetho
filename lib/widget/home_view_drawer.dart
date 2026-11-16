import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/cubit/theme_cubit.dart';
import 'package:doucodetho/cubit/user_info_cubit.dart';
import 'package:doucodetho/locator.dart';
import 'package:doucodetho/model/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewDrawer extends StatefulWidget {
  const HomeViewDrawer({super.key});

  @override
  State<HomeViewDrawer> createState() => _HomeViewDrawerState();
}

class _HomeViewDrawerState extends State<HomeViewDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 180,
            child: DrawerHeader(
              child: BlocBuilder<UserInfoCubit, UserInfo>(
                builder: (context, authInfo) {
                  if (authInfo.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Text(
                        authInfo.username,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        authInfo.email ?? '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        selected: {themeMode},
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          selectedBackgroundColor: Colors.green.shade700,
                          selectedForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        segments: const [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto, size: 18),
                            label: Text('Auto'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode, size: 18),
                            label: Text('Light'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode, size: 18),
                            label: Text('Dark'),
                          ),
                        ],
                        onSelectionChanged: (newSelection) {
                          context
                              .read<ThemeCubit>()
                              .setThemeMode(newSelection.first);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              locator<AuthService>().requestPasswordReset(
                  context.read<UserInfoCubit>().state.email!);
              Navigator.pop(context);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            onPressed: () {
              context.read<UserInfoCubit>().signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
