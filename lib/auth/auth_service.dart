import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailAndPass(
      String email, String password, String username) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
