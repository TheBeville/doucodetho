import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  Future<int> getCurrentStreak(String userID) async {
    final response = await supabase
        .from('streak_data')
        .select('current_streak')
        .eq('id', userID)
        .single();
    return response['current_streak'];
  }

  Future<int> getLongestStreak(String userID) async {
    final response = await supabase
        .from('streak_data')
        .select('longest_streak')
        .eq('id', userID)
        .single();
    return response['longest_streak'];
  }

  Future<DateTime> getLastUpdated(String userID) async {
    final response = await supabase
        .from('streak_data')
        .select('last_updated')
        .eq('id', userID)
        .single();
    return DateTime.parse(response['last_updated']);
  }

  Future<void> incrementCurrentStreak(String userID) async {
    final currentStreak = await getCurrentStreak(userID);
    await supabase
        .from('streak_data')
        .update({'current_streak': currentStreak + 1}).eq('id', userID);
  }

  Future<void> incrementLongestStreak(String userID) async {
    final longestStreak = await getLongestStreak(userID);
    await supabase
        .from('streak_data')
        .update({'longest_streak': longestStreak + 1}).eq('id', userID);
  }

  Future<void> updateLastUpdated(String userID, DateTime date) async {
    await supabase
        .from('streak_data')
        .update({'last_updated': date.toIso8601String().split('T')[0]}).eq(
            'id', userID);
  }

  Future<void> resetCurrentStreak(String userID) async {
    await supabase
        .from('streak_data')
        .update({'current_streak': 0}).eq('id', userID);
  }

  Future<void> resetUserData(String userID) async {
    await supabase.from('streak_data').update({
      'current_streak': 0,
      'longest_streak': 0,
      'day_completed': false,
      'last_updated': DateTime.now().toIso8601String().split('T')[0],
    }).eq('id', userID);
  }
}
