import 'dart:async';

import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/locator.dart';
import 'package:doucodetho/widget/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeAuthService implements AuthService {
  String? lastEmail;
  String? lastPassword;
  Completer<AuthResponse>? loginCompleter;
  Exception? exceptionToThrow;

  @override
  SupabaseClient get supabase => throw UnimplementedError();

  @override
  User? getCurrentUser() => null;

  @override
  Future<String> getCurrentUserName(String userID) async => '';

  @override
  Future<void> signOut() async {}

  @override
  Future<AuthResponse> logInWithEmail({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;

    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    if (loginCompleter != null) {
      return loginCompleter!.future;
    }

    return AuthResponse();
  }

  @override
  Future<AuthResponse?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async =>
      null;

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthService fakeAuthService;

  setUp(() async {
    await locator.reset();
    fakeAuthService = FakeAuthService();
    locator.registerSingleton<AuthService>(fakeAuthService);
  });

  tearDown(() async {
    await locator.reset();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: Scaffold(
        body: LoginForm(),
      ),
    );
  }

  testWidgets('validates required fields before submitting', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap Log In with empty fields
    await tester.tap(find.text('Log In'));
    await tester.pump();

    expect(find.text('Please enter some text'), findsNWidgets(2));
    expect(fakeAuthService.lastEmail, isNull);
  });

  testWidgets(
      'shows loading indicator during login and calls auth service with trimmed email',
      (tester) async {
    final completer = Completer<AuthResponse>();
    fakeAuthService.loginCompleter = completer;

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), '  test@example.com  ');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'secret123');

    await tester.tap(find.text('Log In'));
    await tester.pump();

    // Verify loading indicator is displayed while in progress
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(fakeAuthService.lastEmail, 'test@example.com');
    expect(fakeAuthService.lastPassword, 'secret123');

    // Complete login
    completer.complete(AuthResponse());
    await tester.pump();

    // Verify loading indicator is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets(
      'shows red SnackBar with AuthException message when credentials are invalid',
      (tester) async {
    fakeAuthService.exceptionToThrow =
        const AuthException('Invalid login credentials');

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'user@wrong.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'wrongpass');

    await tester.tap(find.text('Log In'));
    await tester.pump();

    // Verify SnackBar is shown with the exact AuthException message
    expect(find.text('Invalid login credentials'), findsOneWidget);

    final SnackBar snackBar = tester.widget(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.red);
    expect(snackBar.duration, const Duration(seconds: 3));

    // Verify button is restored
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets('shows red SnackBar when API call fails with generic error',
      (tester) async {
    fakeAuthService.exceptionToThrow = Exception('Network connection failed');

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'user@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'password123');

    await tester.tap(find.text('Log In'));
    await tester.pump();

    // Verify SnackBar is shown with the error message
    expect(
        find.text('Login failed: Network connection failed'), findsOneWidget);

    final SnackBar snackBar = tester.widget(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.red);

    // Verify button is restored
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Log In'), findsOneWidget);
  });
}
