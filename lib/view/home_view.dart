import 'package:doucodetho/model/streak_data_model.dart';
import 'package:doucodetho/streak_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String buttonText = 'Yes!';

  @override
  void initState() {
    super.initState();
    context.read<StreakDataCubit>().getStreakData();
  }

  bool checkDayCompleted() {
    final DateTime lastUpdated =
        context.read<StreakDataCubit>().state.lastUpdated;
    final DateTime today =
        DateTime.parse(context.read<StreakDataCubit>().getDates()['today']!);
    print('lastUpdated: $lastUpdated, today: $today');
    return lastUpdated.isAfter(today);
  }

  @override
  Widget build(BuildContext context) {
    // checkDayCompleted() returns true if the day is already completed
    bool showButton = !checkDayCompleted();

    return Scaffold(
      body: BlocBuilder<StreakDataCubit, StreakData>(
        builder: (context, streakData) {
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
                        child: Text(
                          buttonText,
                          style: TextStyle(fontSize: 18),
                        ))
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
                        style: TextStyle(fontSize: 18),
                      )
                    : Text(
                        'day in a row',
                        style: TextStyle(fontSize: 18),
                      ),
                Spacer(flex: 2),
              ],
            ),
          );
        },
      ),
    );
  }
}
