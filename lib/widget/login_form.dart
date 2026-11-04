import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/locator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  SnackBar snackBar = SnackBar(
    content: Text('Password reset email sent!'),
    duration: Duration(seconds: 2),
  );

  Future<void> _onLoginButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await locator<AuthService>().logInWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      } on AuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login failed: ${e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
              ),
              controller: emailController,
              validator: _validator,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: _validator,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 25),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green),
                fixedSize: WidgetStateProperty.all(const Size(355, 50)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              onPressed: _isLoading ? null : _onLoginButtonPressed,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            TextButton(
              onPressed: () {
                if (emailController.text != '') {
                  locator<AuthService>().requestPasswordReset(
                    emailController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter your email address.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(
                'Forgotten your password?',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
