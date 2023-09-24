import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/authProvider.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_screen/home_screen_page.dart';
import 'package:chatapp_firebase/pages/home_screen/home_screen_provider.dart';
import 'package:chatapp_firebase/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'service/getIt_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
     await Firebase.initializeApp();
    //     options: FirebaseOptions(
    //         apiKey: Constants.apiKey,
    //         appId: Constants.appId,
    //         messagingSenderId: Constants.messagingSenderId,
    //         projectId: Constants.projectId
    //     )
    // );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  return  FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: getIt<HomeScreenProvider>()),
            ChangeNotifierProvider.value(value: getIt<AuthProvider>()),
          ],
          child:MaterialApp(
            theme: ThemeData(
                primaryColor: AppStrings.primaryColor,
                scaffoldBackgroundColor: Colors.white),
            debugShowCheckedModeBanner: false,
            home: _isSignedIn ? const HomePage() : const LoginPage(),
          ));});
    }
  }


