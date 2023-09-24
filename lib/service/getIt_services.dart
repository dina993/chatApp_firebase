import 'package:chatapp_firebase/pages/auth/authProvider.dart';
import 'package:get_it/get_it.dart';

import '../pages/home_screen/home_screen_provider.dart';


final getIt = GetIt.instance;


Future<void> setupDependencies() async {
  getIt.registerLazySingleton(() => HomeScreenProvider());
  getIt.registerLazySingleton(() => AuthProvider());
}