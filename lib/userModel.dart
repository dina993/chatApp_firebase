import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fullName="";
  List<String>? groups; // Specify the type of the list elements as String
  String? profilePic="";
  String? id;
  String? email;
  String? password;

  UserModel({
    this.fullName,
    this.groups,
    this.profilePic,
    this.id,
    this.email,this.password
  });

  // Use factory constructors to create instances of the class
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserModel(
      id: snapshot.id,
      email: data!["email"],
      fullName: data["fullName"],
      groups: List<String>.from(data["groups"] ?? []),
      profilePic: data["profilePic"],
      password: data["password"],
    );
  }

  factory UserModel.from(Map<String, dynamic> snapshot) {
    return UserModel(
      id: snapshot["uid"],
      email: snapshot["email"],
      fullName: snapshot["fullName"],
      groups: List<String>.from(snapshot["groups"] ?? []),
      profilePic: snapshot["profilePic"],
      password: snapshot["password"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": id,
      "fullName": fullName,
      'email': email,
      'groups': groups,
      'profilePic': profilePic,
      "password":password,
    };
  }
}
