import 'package:doucodetho/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:doucodetho/locator.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback alreadyHaveAnAccount;
  const SignupForm({super.key, required this.alreadyHaveAnAccount});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  void _onSignupButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      } else {
        final result = await locator<AuthService>().signUpWithEmail(
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(result == null ? 'Sign up failed' : 'Sign up successful'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              validator: _validator,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: usernameController,
              validator: _validator,
              decoration: InputDecoration(
                hintText: 'Display Name',
              ),
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
            SizedBox(height: 10),
            TextFormField(
              controller: confirmPasswordController,
              validator: _validator,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
              ),
            ),
            SizedBox(height: 25),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                fixedSize: WidgetStateProperty.all(Size(355, 50)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              onPressed: _onSignupButtonPressed,
              child: Text(
                'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: widget.alreadyHaveAnAccount,
              child: Text(
                'Already have an account?',
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
