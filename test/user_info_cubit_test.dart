import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/cubit/user_info_cubit.dart';
import 'package:doucodetho/home_widget/home_widget_service.dart';
import 'package:doucodetho/locator.dart';
import 'package:doucodetho/model/user_info_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeAuthService implements AuthService {
  User? mockUser;
  String mockUsername = '';
  bool shouldThrow = false;
  bool signOutCalled = false;

  @override
  SupabaseClient get supabase => throw UnimplementedError();

  @override
  User? getCurrentUser() => mockUser;

  @override
  Future<String> getCurrentUserName(String userID) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return mockUsername;
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Future<AuthResponse> logInWithEmail({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    throw UnimplementedError();
  }
}

class FakeHomeWidgetService implements HomeWidgetService {
  String? savedName;
  bool cleared = false;

  @override
  Future<void> updateWidgetData({
    String? name,
    int? currentStreak,
    bool? dayCompleted,
  }) async {
    savedName = name;
  }

  @override
  Future<void> clearWidgetData() async {
    cleared = true;
  }

  @override
  Future<void> refreshWidget() async {}
}

void main() {
  late FakeAuthService fakeAuthService;
  late FakeHomeWidgetService fakeHomeWidgetService;

  setUp(() async {
    await locator.reset();
    fakeAuthService = FakeAuthService();
    fakeHomeWidgetService = FakeHomeWidgetService();
    locator.registerSingleton<AuthService>(fakeAuthService);
    locator.registerSingleton<HomeWidgetService>(fakeHomeWidgetService);
  });

  tearDown(() async {
    await locator.reset();
  });

  group('UserInfoCubit', () {
    test('initial state defaults to isLoading: false with empty fields', () {
      final cubit = UserInfoCubit();
      expect(cubit.state.userID, '');
      expect(cubit.state.username, '');
      expect(cubit.state.email, '');
      expect(cubit.state.isLoading, isFalse);
      cubit.close();
    });

    test('initial state can be passed explicitly', () {
      final cubit = UserInfoCubit(
        UserInfo(
          userID: '123',
          username: 'Test',
          email: 'test@example.com',
          isLoading: true,
        ),
      );
      expect(cubit.state.userID, '123');
      expect(cubit.state.username, 'Test');
      expect(cubit.state.email, 'test@example.com');
      expect(cubit.state.isLoading, isTrue);
      cubit.close();
    });

    test('getUserName emits loading then sets user data when user exists',
        () async {
      final cubit = UserInfoCubit();
      final states = <UserInfo>[];
      final subscription = cubit.stream.listen(states.add);

      fakeAuthService.mockUser = User(
        id: 'user_abc',
        appMetadata: {},
        userMetadata: {},
        aud: '',
        createdAt: '',
        email: 'user@example.com',
      );
      fakeAuthService.mockUsername = 'CodeMaster';

      await cubit.getUserName();
      await pumpEventQueue();

      expect(states.length, 2);
      // First state is loading
      expect(states[0].isLoading, isTrue);
      // Second state is loaded
      expect(states[1].isLoading, isFalse);
      expect(states[1].userID, 'user_abc');
      expect(states[1].username, 'CodeMaster');
      expect(states[1].email, 'user@example.com');
      expect(fakeHomeWidgetService.savedName, 'CodeMaster');

      await subscription.cancel();
      await cubit.close();
    });

    test('getUserName sets isLoading: false when an error occurs', () async {
      final cubit = UserInfoCubit();
      fakeAuthService.mockUser = User(
        id: 'user_abc',
        appMetadata: {},
        userMetadata: {},
        aud: '',
        createdAt: '',
      );
      fakeAuthService.shouldThrow = true;

      await cubit.getUserName();

      expect(cubit.state.isLoading, isFalse);
      await cubit.close();
    });

    test('signOut clears user data and sets isLoading to false', () async {
      final cubit = UserInfoCubit(
        UserInfo(
          userID: '123',
          username: 'User',
          email: 'a@b.com',
          isLoading: true,
        ),
      );

      await cubit.signOut();

      expect(cubit.state.userID, '');
      expect(cubit.state.username, '');
      expect(cubit.state.email, '');
      expect(cubit.state.isLoading, isFalse);
      expect(fakeAuthService.signOutCalled, isTrue);
      expect(fakeHomeWidgetService.cleared, isTrue);

      await cubit.close();
    });
  });
}
