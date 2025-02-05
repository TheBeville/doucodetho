import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final supabase = Supabase.instance.client;
// final data = await supabase.from('consecutive_days').select();

class ConsecutiveDaysCubit extends Cubit<int> {
  ConsecutiveDaysCubit() : super(0);

  void increment() {
    emit(state + 1);
  }

  void reset() => emit(0);
}
