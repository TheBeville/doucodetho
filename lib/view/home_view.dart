import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/locator.dart';
import 'package:doucodetho/model/streak_data_model.dart';
import 'package:doucodetho/cubit/streak_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String buttonText = 'Tap to complete';

  @override
  void initState() {
    super.initState();
    context.read<StreakDataCubit>().getStreakData();
  }

  void signOut() {
    locator<AuthService>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StreakDataCubit, StreakData>(
        builder: (context, streakData) {
          bool showButton = !streakData.dayCompleted;

          return Center(
            child: Column(
              children: [
                SizedBox(height: 100),
                Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Do u code tho?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Spacer(flex: 1),
                showButton
                    ? FilledButton(
                        onPressed: () {
                          context.read<StreakDataCubit>().incrementStreaks();
                          setState(() {
                            showButton = false;
                            buttonText = 'Well done!';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Good job, day completed!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white10),
                          fixedSize: WidgetStateProperty.all(Size(200, 250)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Text(
                              '❓',
                              style: TextStyle(fontSize: 125),
                            ),
                            Text(
                              buttonText,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Text(
                            '🔥',
                            style: TextStyle(fontSize: 150),
                          ),
                          Text(
                            'Well done!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                Spacer(flex: 1),
                Text(
                  'Current Streak',
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  streakData.current.toString(),
                  style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
                ),
                streakData.current != 1
                    ? Text(
                        'days in a row',
                        style: TextStyle(fontSize: 20),
                      )
                    : Text(
                        'day in a row',
                        style: TextStyle(fontSize: 20),
                      ),
                Text('(Longest Streak: ${streakData.longest})'),
                Spacer(flex: 2),
                TextButton(
                    onPressed: signOut,
                    child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(height: 25),
              ],
            ),
          );
        },
      ),
    );
  }
}
