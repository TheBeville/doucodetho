import 'package:doucodetho/view/login_view.dart';
import 'package:flutter/material.dart';

class LoginSegmentedButton extends StatefulWidget {
  final Segment selectedSegment;
  final ValueChanged<Segment> onSelectionChanged;
  const LoginSegmentedButton({
    super.key,
    required this.selectedSegment,
    required this.onSelectionChanged,
  });

  @override
  State<LoginSegmentedButton> createState() => _LoginSegmentedButtonState();
}

class _LoginSegmentedButtonState extends State<LoginSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: SegmentedButton(
        selected: {widget.selectedSegment},
        style: SegmentedButton.styleFrom(
          animationDuration: Duration(milliseconds: 350),
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[350],
          selectedBackgroundColor: widget.selectedSegment == Segment.login
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
                fontSize: widget.selectedSegment == Segment.login ? 20 : 16,
                fontWeight: widget.selectedSegment == Segment.login
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
                fontSize: widget.selectedSegment == Segment.signup ? 20 : 16,
                fontWeight: widget.selectedSegment == Segment.signup
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
        onSelectionChanged: (Set<Segment> newSelection) {
          widget.onSelectionChanged(newSelection.first);
        },
      ),
    );
  }
}
