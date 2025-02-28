import 'package:doucodetho/widget/login_form.dart';
import 'package:doucodetho/widget/login_segmented_button.dart';
import 'package:doucodetho/widget/signup_form.dart';
import 'package:flutter/material.dart';

enum Segment { login, signup }

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Segment _selectedSegment = Segment.login;

  // toggles between login and signup
  void _handleSegmentChanged(Segment newSegment) {
    setState(() {
      _selectedSegment = newSegment;
    });
  }

  // switches to login view when 'Already have an account?' is clicked
  void _toggleToLogin() {
    setState(() {
      _selectedSegment = Segment.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 85,
            ),
            Text(
              'Doucodetho',
              style: TextStyle(
                fontSize: 34,
                height: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '[do-you-code-though?]',
              style: TextStyle(
                fontSize: 16,
                height: 1,
              ),
            ),
            SizedBox(height: 30),
            LoginSegmentedButton(
              selectedSegment: _selectedSegment,
              onSelectionChanged: _handleSegmentChanged,
            ),
            SizedBox(height: 125),
            _selectedSegment == Segment.login
                ? LoginForm()
                : SignupForm(alreadyHaveAnAccount: _toggleToLogin),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
