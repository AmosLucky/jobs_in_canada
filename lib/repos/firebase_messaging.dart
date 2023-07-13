import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repos/general_repo.dart';
import '../screens/main_scree.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../utils/global.dart';
import '../utils/constants.dart';


import 'dart:convert';

class FirebaseNotification {
  var context;
  FirebaseNotification(this.context) {
    requestPermission();
    getToken();
    initialize();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initialize() {
    var androidInitialize =
        const AndroidInitializationSettings("assets/images/logo.png");
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitialize,
      iOS: initializationSettingsDarwin,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen((event) async {
      print("------ MESSAGE ------");

      print(event.notification!.title);
      print(event.notification!.body);

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          event.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: event.notification!.title.toString(),
          htmlFormatContent: true);

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails("1", "Canada jobs",
              channelDescription: "Canada jobs",
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              playSound: true,
              priority: Priority.high);
      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.show(
          Random().nextInt(1000),
          event.notification!.title,
          event.notification!.body,
          notificationDetails,
          payload: event.data['body']);
    });
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    // ...
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await GeneralRepo().navigateToScreen2(
      MainScreen(),
    );
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }

  onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      // setState(() {
      //   deviceToken = token!;
      //   print(deviceToken);
      //   saveToken(deviceToken);
      // });

      deviceToken = token!;
      print("#################################");
      print(deviceToken);
      saveToken(deviceToken);
      try {
        var response = await http
            .post(Uri.parse(save_device_token), body: {"device_token": token});
        print("error==" + response.statusCode.toString());
        print("error==" + jsonDecode(response.body));
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data);

          return data;
        } else {
          return [];
        }
      } catch (e) {
        print("error==" + e.toString());
        return [];
      }
    });
  }

  saveToken(String token) async {
    var uuid = Uuid().v1();
    await FirebaseFirestore.instance
        .collection("job_app")
        .doc(uuid)
        .set({"token": token});
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted profisional Permission ");
    } else {
      print("Permission declined");
    }
  }
}
