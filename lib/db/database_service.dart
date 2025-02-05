import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  Future<List> getCompletedDays() async {
    final response =
        await supabase.from('completed_days').select('created_at, coding_done');
    return response as List;
  }

  Future<void> markDayAsCompleted() async {
    await supabase.from('completed_days').insert({
      'last_updated':
          (DateTime.now().year + DateTime.now().month + DateTime.now().day),
      'coding_done': true,
    });
  }

  Future<void> unmarkDayAsCompleted(user) async {
    await supabase
        .from('completed_days')
        .update({'coding_done': false}).eq('username', user);
  }
}
