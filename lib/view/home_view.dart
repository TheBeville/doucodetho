import 'package:doucodetho/cubit/user_info_cubit.dart';
import 'package:doucodetho/model/user_info_model.dart';
import 'package:doucodetho/model/streak_data_model.dart';
import 'package:doucodetho/cubit/streak_data_cubit.dart';
import 'package:doucodetho/widget/home_view_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<StreakDataCubit>().getStreakData();
    context.read<UserInfoCubit>().getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: HomeViewDrawer(),
      body: BlocBuilder<StreakDataCubit, StreakData>(
        builder: (context, streakData) {
          bool showButton = !streakData.dayCompleted;

          Future<void> refreshData() async {
            await context.read<StreakDataCubit>().getStreakData();
            if (context.mounted) {
              await context.read<UserInfoCubit>().getUserName();
            }
          }

          return RefreshIndicator(
            onRefresh: refreshData,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      kToolbarHeight,
                  child: Center(
                    child: Column(
                      children: [
                        BlocBuilder<UserInfoCubit, UserInfo>(
                          builder: (context, authInfo) {
                            return Text(
                              'Hello, ${authInfo.username}!',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
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
                                onPressed: () async {
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  await context
                                      .read<StreakDataCubit>()
                                      .incrementStreaks();
                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Good job, day completed!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white10),
                                  fixedSize:
                                      WidgetStateProperty.all(Size(200, 250)),
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
                                    const Text(
                                      'Tap to complete',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
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
                        showButton
                            ? SizedBox(height: 50)
                            : Column(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      final messenger =
                                          ScaffoldMessenger.of(context);
                                      await context
                                          .read<StreakDataCubit>()
                                          .undoIncrementStreaks();
                                      if (!mounted) return;
                                      messenger.showSnackBar(
                                        const SnackBar(
                                          content: Text('Undid completion'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Text('Undo ↩️',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black)),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                        Text(
                          'Current Streak',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          streakData.current.toString(),
                          style: TextStyle(
                              fontSize: 56, fontWeight: FontWeight.bold),
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
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
