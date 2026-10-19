import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/home_widget/home_widget_service.dart';
import 'package:doucodetho/model/user_info_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../locator.dart';

class UserInfoCubit extends Cubit<UserInfo> {
  UserInfoCubit()
      : super(
          UserInfo(
            userID: '',
            username: '',
            email: '',
          ),
        );

  Future<void> getUserName() async {
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
        email: user?.email! ?? '',
      ),
    );

    await locator<HomeWidgetService>().updateWidgetData(name: username);
  }

  Future<void> signOut() async {
    await locator<AuthService>().signOut();
    emit(
      UserInfo(
        userID: '',
        username: '',
        email: '',
      ),
    );

    await locator<HomeWidgetService>().clearWidgetData();
  }
}
