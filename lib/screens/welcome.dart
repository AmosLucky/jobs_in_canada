import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/signin.dart';
import '../screens/signup.dart';
import '../utils/colors.dart';

import '../functions/navigate.dart';
import '../utils/assets.dart';
import '../utils/dimensions.dart';
import '../widgets/opacity_bg.dart';
import '../widgets/roundbutton.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return Container(
                  child: OpacityBg(
                      context,
                      Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                //color: Colors.amber,
                                child: Image.asset(
                                  GetAssts.getLogo(),
                                  width: Dimentions.getSize(context).width / 2,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Find Your",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "perferct job!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ]),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // roundButton(
                              //     context: context,
                              //     bgColor: Colors.green,
                              //     text: "Continue as a guest",
                              //     textColor: Colors.white,
                              //     onTap: () async {
                              //       FirebaseAuth.instance.signInAnonymously();
                              //       NavigateLeftToRight(context, MainScreen());
                              //     }),
                              SizedBox(
                                height: 15,
                              ),
                              roundButton(
                                  context: context,
                                  bgColor: AppTheme.primaryColor,
                                  text: "Sign Up",
                                  textColor: Colors.white,
                                  onTap: () {
                                    print("object");
                                    NavigateLeftToRight(context, SignUp());
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              roundButton(
                                  context: context,
                                  bgColor: AppTheme.whitBg,
                                  text: "Sign In",
                                  textColor: Colors.black,
                                  onTap: () {
                                    print("object");
                                    NavigateLeftToRight(context, SignIn());
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                            ]),
                      )));
            }),
      ),
    );
  }
}
