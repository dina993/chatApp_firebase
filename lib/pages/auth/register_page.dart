import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/authProvider.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_screen/home_screen_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../service/getIt_services.dart';
import '../../shared/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getIt<AuthProvider>().isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: getIt<AuthProvider>().registerKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                         Text(AppStrings.register,
                          style:const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10),
                         Text(AppStrings.createAccount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                        Image.asset("assets/register.jpg"),
                        TextFormField(
                          controller: getIt<AuthProvider>().fullName,
                          decoration: textInputDecoration.copyWith(
                              labelText: AppStrings.fullName,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                              )),
                          onChanged: (val) {
                            setState(() {
                              AppStrings.fullName = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller:  getIt<AuthProvider>().email,
                          decoration: textInputDecoration.copyWith(
                              labelText: AppStrings.email,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                              )),
                          onChanged: (val) {
                            setState(() {
                              getIt<AuthProvider>().email.text = val;
                            });
                          },

                          validator: (val) {
                            getIt<AuthProvider>().validateEmail(val);
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: getIt<AuthProvider>().password,
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: AppStrings.password,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                              )),
                          validator: (val) {
                            getIt<AuthProvider>().validatePassword(val);
                          },
                          onChanged: (val) {
                            setState(() {
                              getIt<AuthProvider>().password.text = val;
                            });
                          },
                        ),
                        const SizedBox(height: 30,),
                        SizedBox(height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child:  Text(
                              AppStrings.register,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              getIt<AuthProvider>().register(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text.rich(TextSpan(
                          text: AppStrings.haveAccount,
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text:AppStrings.login,
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginPage());
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }



}
