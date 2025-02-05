import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/locator.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
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
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              controller: passwordController,
              validator: _validator,
            ),
            SizedBox(height: 25),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green),
                fixedSize: WidgetStateProperty.all(Size(355, 50)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              onPressed: () {
                // TODO: finish Form validation
                if (_formKey.currentState!.validate()) {
                  locator<AuthService>().signInWithEmail(
                    emailController.text,
                    passwordController.text,
                  );
                  // TODO: Navigate to HomeView after successful login
                  return;
                }
              },
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgotten your password?',
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
