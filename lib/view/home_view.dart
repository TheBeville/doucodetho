import 'package:doucodetho/consecutive_days_cubit.dart';
import 'package:doucodetho/db/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doucodetho/locator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool buttonClicked = false;
  String buttonText = 'Yes!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ConsecutiveDaysCubit, int>(
        builder: (context, consecutiveDays) {
          return Center(
            child: Column(
              children: [
                Spacer(flex: 3),
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
                  ),
                ),
                SizedBox(height: 10),
                !buttonClicked
                    ? FilledButton(
                        onPressed: () {
                          context.read<ConsecutiveDaysCubit>().increment();
                          locator<DatabaseService>().markDayAsCompleted();
                          setState(() {
                            buttonClicked = true;
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
                    : Text(
                        buttonText,
                        style: TextStyle(fontSize: 34, color: Colors.green),
                      ),
                Spacer(flex: 1),
                Text(
                  'Current Streak',
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  consecutiveDays.toString(),
                  style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
                ),
                consecutiveDays > 1
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
