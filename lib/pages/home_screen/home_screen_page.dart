
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_screen/home_screen_provider.dart';
import 'package:chatapp_firebase/pages/home_screen/home_screen_widgets.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/getIt_services.dart';
import 'package:chatapp_firebase/shared/constants.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    getIt<HomeScreenProvider>().gettingUserData();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context,  value, child)
    {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(
                  Icons.search,
                ))
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          title:  Text(
           AppStrings.appName,
            style:const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    value.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    value.email,
                  ),
                  currentAccountPicture:
                  CircleAvatar(radius: 50,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  selected: true,
                  leading: Icon(Icons.group),
                  title: Text(
                    "Groups",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {
                    nextScreenReplace(
                      context,
                      ProfilePage(
                        userName: value.userName,
                        email: value.email,
                      ),
                    );
                  },
                  leading: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    bool logoutConfirmed = await showLogoutConfirmationDialog(context);
                    if (logoutConfirmed) {
                      await value.authService.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false,
                      );
                    }
                  },
                  leading: Icon(Icons.exit_to_app),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),

          body: HomeScreenWidgets().groupList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            HomeScreenWidgets().popUpDialog(context);
          },
          elevation: 0,
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      );
    });
  }
   showLogoutConfirmationDialog(BuildContext context)  {
    return  showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }


}
