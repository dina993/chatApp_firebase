
import 'package:chatapp_firebase/pages/home_screen/home_screen_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/service/getIt_services.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';

class AuthProvider extends ChangeNotifier{

  bool isLoading = false;
  final registerKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password =TextEditingController();
  TextEditingController fullName =TextEditingController();
  AuthService authService = AuthService();

  validateEmail(String? val){
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val!)
        ? null
        : "Please enter a valid email";
  }

  validatePassword(String? val){
    if (val!.length < 6) {
      return "Password must be at least 6 characters";
    } else {
      return null;
    }
  }

  register(BuildContext context) async {
    if (registerKey.currentState!.validate()) {
        isLoading = true;
      await authService.registerUserWithEmailandPassword(fullName.text, email.text, password.text).then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email.text);
          await HelperFunctions.saveUserNameSF(fullName.text);
          nextScreenReplace(context, const HomePage());
          notifyListeners();
        } else {
          showSnackbar(context, Colors.red, value);
            isLoading = false;
            notifyListeners();
        }
      });
    }
  }
  login(BuildContext context) async {
    if (registerKey.currentState!.validate()) {
       isLoading = true;
      await AuthService().loginWithUserNameandPassword(getIt<AuthProvider>().email.text, getIt<AuthProvider>().password.text).then((value) async {
        if (value == true) {
          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(getIt<AuthProvider>().email.text);
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(getIt<AuthProvider>().email.text);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          showSnackbar(context, Colors.red, value);
            getIt<AuthProvider>().isLoading = false;

        }
      });
    }
  }
}