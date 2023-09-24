
import 'package:chatapp_firebase/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreHelper {
  FirestoreHelper._();
  UserModel? userModel;
  static FirestoreHelper firestoreHelper = FirestoreHelper._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  createNewUser(UserModel userModel, String userId) async {
    firestore.collection('users').doc(userId).set(userModel.toMap());
  }

  exitApp() async {
    userModel = null;
  }

  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore.collection('users').doc(userId).get();
   userModel =  UserModel.fromDocumentSnapshot(documentSnapshot);
    return userModel;
  }



}