import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/db/database_service.dart';
import 'package:doucodetho/model/streak_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locator.dart';

class StreakDataCubit extends Cubit<StreakData> {
  StreakDataCubit()
      : super(
          StreakData(
            current: 0,
            longest: 0,
            dayCompleted: false,
            lastUpdated: DateTime.now(),
          ),
        );

  void getStreakData() async {
    if (locator<AuthService>().getCurrentUser() == null) return;

    final String userID = locator<AuthService>().getCurrentUser()!.id;
    final int currentStreak = await locator<DatabaseService>().getCurrentStreak(
      userID,
    );
    final int longestStreak = await locator<DatabaseService>().getLongestStreak(
      userID,
    );
    final DateTime lastUpdated =
        await locator<DatabaseService>().getLastUpdated(
      userID,
    );

    bool dayCompleted = false;
    if (lastUpdated.year == DateTime.now().year &&
        lastUpdated.month == DateTime.now().month &&
        lastUpdated.day == DateTime.now().day) {
      dayCompleted = true;
    }

    final DateTime yesterday = DateTime.parse(getDates()['yesterday']!);
    int updatedCurrentStreak = currentStreak;
    if (lastUpdated.isBefore(yesterday)) {
      updatedCurrentStreak = 0;
    }

    emit(StreakData(
      current: updatedCurrentStreak,
      longest: longestStreak,
      dayCompleted: dayCompleted,
      lastUpdated: lastUpdated,
    ));
  }

  void incrementStreaks() async {
    if (locator<AuthService>().getCurrentUser() == null) return;

    final int currentStreak = state.current;
    final int longestStreak = state.longest;
    final bool dayCompleted = true;
    final DateTime lastUpdated = state.lastUpdated;
    final String userID = locator<AuthService>().getCurrentUser()!.id;

    int current = currentStreak;
    int longest = longestStreak;

    if (lastUpdated.year < DateTime.now().year ||
        lastUpdated.month < DateTime.now().month ||
        lastUpdated.day < DateTime.now().day) {
      current = await incrementCurrentStreak();
      if (longestStreak == currentStreak) {
        longest = await incrementLongestStreak();
      }
      await locator<DatabaseService>()
          .updateLastUpdated(userID, DateTime.now());
    }

    emit(StreakData(
      current: current,
      longest: longest,
      dayCompleted: dayCompleted,
      lastUpdated: DateTime.now(),
    ));
  }

  Future<int> incrementCurrentStreak() async {
    final String userID = locator<AuthService>().getCurrentUser()!.id;
    await locator<DatabaseService>().incrementCurrentStreak(userID);
    final int currentStreak =
        await locator<DatabaseService>().getCurrentStreak(userID);
    return currentStreak;
  }

  Future<int> incrementLongestStreak() async {
    final String userID = locator<AuthService>().getCurrentUser()!.id;
    await locator<DatabaseService>().incrementLongestStreak(userID);
    final int longestStreak =
        await locator<DatabaseService>().getLongestStreak(userID);
    return longestStreak;
  }

  Map<String, String> getDates() {
    final String year = DateTime.now().year.toString();
    final String month = DateTime.now().month > 9
        ? DateTime.now().month.toString()
        : '0${DateTime.now().month}';
    final String day = DateTime.now().day > 10
        ? (DateTime.now().day).toString()
        : '0${(DateTime.now().day)}';
    final String yesterday = DateTime.now().day > 10
        ? (DateTime.now().day - 1).toString()
        : '0${(DateTime.now().day - 1)}';

    final Map<String, String> dates = {
      'today': '$year-$month-$day',
      'yesterday': '$year-$month-$yesterday'
    };
    return dates;
  }

  // TODO: refactor to also reset the Supabase database
  void resetCubit() => emit(
        StreakData(
          current: 0,
          longest: 0,
          dayCompleted: false,
          lastUpdated: DateTime.now(),
        ),
      );
}
