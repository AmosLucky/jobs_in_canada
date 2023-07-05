import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../models/post_mode.dart';
import '../models/user_model.dart';
import '../repos/post_repo.dart';
import '../repos/user_repo.dart';
import '../screens/welcome.dart';
import '../utils/admob_ids.dart';
import '../utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/splash_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // handle action
}
AppOpenAd? myAppOpenAd;

loadAppOpenAd() {
  AppOpenAd.load(
      adUnitId: AdsIds.appOpenAdUnitId, //Your ad Id from admob
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            myAppOpenAd = ad;
            myAppOpenAd!.show();
          },
          onAdFailedToLoad: (error) {}),
      orientation: AppOpenAd.orientationPortrait);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance
    ..initialize()
    ..updateRequestConfiguration(RequestConfiguration(
      testDeviceIds: <String>["93D185EE7A5B8DCB96847646A4DD8058"],
    ));
  loadAppOpenAd();

  await Firebase.initializeApp();

  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FacebookAudienceNetwork.init(
      //testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
      iOSAdvertiserTrackingEnabled: true //default false
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostRepo()),
        ChangeNotifierProvider(create: (_) => UserRepo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: EasyLoading.init(),
        home: const SplashScreen(),
      ),
    );
  }
}
