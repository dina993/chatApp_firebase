


import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier{
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool isLoading = false;
  String groupName = "";


  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
        email = value!;
     notifyListeners();
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
        userName = val!;
     notifyListeners();
    });

    await DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).getUserGroups(FirebaseAuth.instance.currentUser!.uid).
    then((snapshot) {
        groups = snapshot;
        print('11111111111===$groups');
        notifyListeners();

        return groups;

    });
  }



}