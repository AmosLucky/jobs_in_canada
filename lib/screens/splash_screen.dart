import 'dart:async';

import 'package:flutter/material.dart';
import '../repos/ads_manager.dart';
import '../repos/user_repo.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';

import '../repos/firebase_messaging.dart';
import '../widgets/opacity_bg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  var controler;
  var animation;
  bool isError = false;

  void initState() {
    Adverts().fetchAddTime();
    controler =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween(begin: 0.0, end: 1.0).animate(controler);
    controler.forward();

    ////INCREMENT ADS

    Adverts().increment();
    Adverts().increment();

    Timer(Duration(seconds: 3), () {
      UserRepo().signInOldUser(context);
      FirebaseNotification(context);

      //UserRepo().signInWithId(String user_id, context);
    });

    //Timer(Duration(seconds: 4), () {});
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controler.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: OpacityBg(
          context,
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                    scale: animation,
                    child: Image.asset(
                      GetAssts.getImage("logo1.png"),
                      width: 200,
                    )),
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(0.5, 1.0),
                    ),
                  ),
                  child: Text(
                    slogan,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Visibility(
                    visible: isError,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Internet Error: Please check your network connection"),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              var route = MaterialPageRoute(
                                  builder: (BuildContext) => SplashScreen());
                              Navigator.push(context, route);
                            },
                            child: Text("Retry"))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
