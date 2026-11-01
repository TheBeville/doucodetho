import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/home_widget/home_widget_service.dart';
import 'package:doucodetho/model/user_info_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../locator.dart';

class UserInfoCubit extends Cubit<UserInfo> {
  UserInfoCubit([UserInfo? initialState])
      : super(
          initialState ??
              UserInfo(
                userID: '',
                username: '',
                email: '',
                isLoading: false,
              ),
        );

  Future<void> getUserName({bool isRefresh = false}) async {
    if (!isRefresh || state.username.isEmpty) {
      emit(
        state.copyWith(isLoading: true),
      );
    }

    try {
      final user = locator<AuthService>().getCurrentUser();
      final String username;

      if (user != null) {
        username = await locator<AuthService>().getCurrentUserName(user.id);
      } else {
        username = '';
      }

      emit(
        UserInfo(
          userID: user?.id ?? '',
          username: username,
          email: user?.email ?? '',
          isLoading: false,
        ),
      );

      if (locator.isRegistered<HomeWidgetService>()) {
        await locator<HomeWidgetService>().updateWidgetData(name: username);
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false),
      );
    }
  }

  Future<void> signOut() async {
    await locator<AuthService>().signOut();
    emit(
      UserInfo(
        userID: '',
        username: '',
        email: '',
        isLoading: false,
      ),
    );

    if (locator.isRegistered<HomeWidgetService>()) {
      await locator<HomeWidgetService>().clearWidgetData();
    }
  }
}
