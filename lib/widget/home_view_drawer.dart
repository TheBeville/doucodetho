import 'package:doucodetho/auth/auth_service.dart';
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
                  return Column(
                    children: [
                      Text(
                        authInfo.username,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        authInfo.email!,
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
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
