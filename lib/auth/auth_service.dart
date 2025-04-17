import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> logInWithEmail({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          // TODO: fix Supabase trigger to avoid NULL value
          'last_updated': yesterday.toIso8601String().split('T')[0],
        },
      );
      return response;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  User? getCurrentUser() {
    return supabase.auth.currentSession?.user;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
