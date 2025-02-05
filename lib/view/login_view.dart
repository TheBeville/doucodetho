import 'package:doucodetho/widget/login_form.dart';
import 'package:doucodetho/widget/signup_form.dart';
import 'package:flutter/material.dart';

enum Segment { login, signup }

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Segment selectedSegment = Segment.login;

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
                // color: Colors.blueAccent,
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
            SizedBox(
              width: 250,
              height: 50,
              child: SegmentedButton(
                selected: {selectedSegment},
                style: SegmentedButton.styleFrom(
                  animationDuration: Duration(milliseconds: 350),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[350],
                  selectedBackgroundColor: selectedSegment == Segment.login
                      ? Colors.green
                      : Colors.blueAccent,
                  selectedForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                showSelectedIcon: false,
                segments: [
                  ButtonSegment<Segment>(
                    value: Segment.login,
                    label: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: selectedSegment == Segment.login ? 20 : 16,
                        fontWeight: selectedSegment == Segment.login
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  ButtonSegment<Segment>(
                    value: Segment.signup,
                    label: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: selectedSegment == Segment.signup ? 20 : 16,
                        fontWeight: selectedSegment == Segment.signup
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
                onSelectionChanged: (Set<Segment> newSelection) {
                  setState(() => selectedSegment = newSelection.first);
                },
              ),
            ),
            SizedBox(height: 125),
            selectedSegment == Segment.login ? LoginForm() : SignupForm(),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
