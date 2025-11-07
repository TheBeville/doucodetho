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
          'last_updated': yesterday.toIso8601String().split('T')[0],
        },
      );
      return response;
    } catch (e) {
      throw Exception('Error signing up: $e');
    }
  }

  void requestPasswordReset(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  User? getCurrentUser() {
    return supabase.auth.currentSession?.user;
  }

  Future<String> getCurrentUserName(String userID) async {
    final response = await supabase
        .from('profiles')
        .select('username')
        .eq('id', userID)
        .single();
    return response['username'];
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
