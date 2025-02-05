import 'package:doucodetho/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:doucodetho/locator.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

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
              decoration: InputDecoration(
                hintText: 'Email',
              ),
              controller: emailController,
              validator: _validator,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Display Name',
              ),
              controller: usernameController,
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
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Confirm Password',
              ),
              controller: confirmPasswordController,
              validator: _validator,
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
              child: Text(
                'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // TODO: finish Form validation
                if (_formKey.currentState!.validate()) {
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Passwords do not match'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  } else {
                    locator<AuthService>().signUpWithEmailAndPass(
                      emailController.text,
                      usernameController.text,
                      passwordController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign up successful'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    // TODO: Navigate to LoginView after successful sign up
                  }
                }
              },
            ),
            TextButton(
              onPressed: () {},
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
