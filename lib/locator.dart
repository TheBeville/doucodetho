import 'package:doucodetho/auth/auth_service.dart';
import 'package:doucodetho/db/database_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => AuthService());
}
