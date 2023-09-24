

import 'package:chatapp_firebase/pages/home_screen/home_screen_provider.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/getIt_services.dart';

class HomeScreenWidgets {


  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title:const Center(
                child:  Text(
                  "Create a group",
                  textAlign: TextAlign.left,style: TextStyle(fontSize: 15),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getIt<HomeScreenProvider>().isLoading == true
                  ? Center(
                    child: CircularProgressIndicator(
                        color: Theme
                            .of(context)
                            .primaryColor),
                  )
                      : TextField(
                    onChanged: (val) {
                      setState(() {
                        getIt<HomeScreenProvider>().groupName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor.withOpacity(0.22)),
                            borderRadius: BorderRadius.circular(12)),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor),
                            borderRadius: BorderRadius.circular(12))),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 108,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: Color(0xFFECF1F6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),child:
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },

                          child: const Text("Cancel",style: TextStyle(fontSize: 13,color: Colors.black),),
                        )),SizedBox(width: 10,),
                    Container(
                        width: 108,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Color(0xFFECF1F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),child:
                    TextButton(
                      onPressed: () async {
                        if (getIt<HomeScreenProvider>().groupName != "") {
                          setState(() {
                            getIt<HomeScreenProvider>().isLoading = true;
                          });
                          await DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).createGroup(getIt<HomeScreenProvider>().userName,
                              FirebaseAuth.instance.currentUser!.uid, getIt<HomeScreenProvider>().groupName)
                              .whenComplete(() {
                            getIt<HomeScreenProvider>().isLoading = false;
                          });

                          Navigator.of(context).pop();
                          showSnackbar(
                              context, Colors.green, "Group created successfully.");
                        }
                      },
                      child: const Text("Create",style: TextStyle(fontSize: 13,color: Colors.black),),
                    ))],
                ),



              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: getIt<HomeScreenProvider>().groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return Container(
                color:const Color(0xFFF9FAFC),
                child: ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex = (snapshot.data['groups'].length)-index - 1;
                    return GroupTile(
                          groupId: snapshot.data['groups'][index],
                         //  groupId: getIt<HomeScreenProvider>().getId(snapshot.data['groups'][reverseIndex]),
                        groupName: getIt<HomeScreenProvider>().getName(snapshot.data['groups'][reverseIndex]),
                        userName:snapshot.data['fullName']);
                  },
                ),
              );
            }
            else {
              return noGroupWidget(context);
            }
          } else {
            return noGroupWidget(context);
          }
        }
        else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme
                    .of(context)
                    .primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

}