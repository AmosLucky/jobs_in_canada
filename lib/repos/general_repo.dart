import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../functions/app_update.dart';
import '../functions/share_content.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import '../utils/global.dart';

import 'ads_manager.dart';

class GeneralRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  navigateToScreen(BuildContext context, Widget child) {
    var route = MaterialPageRoute(builder: (BuildContext) => child);
    Navigator.push(context, route);
  }

  navigateToScreen2(Widget child) {
    var route = MaterialPageRoute(builder: (BuildContext) => child);
    navigatorKey.currentState!.push(route);
  }

  void checkUpdate(BuildContext context, String title, String message) async {
    print("=========");
    var request = await http.get(Uri.parse(adsSettingUrl));
    try {
      if (request.statusCode == 200) {
        var body = jsonDecode(request.body);

        if (body["current_version"] > appVersion) {
          showAlertDialogUPdate(context, title, message);
        }
      } else {}
    } catch (e) {
      print(e);
    }
  }

  showMessge(BuildContext context) async {
    QuerySnapshot<Map<String, dynamic>> messages =
        await firebaseFirestore.collection(messages_database).get();
    messages.docs.forEach((element) {
      //print("[[[[[[[[]]]]]]]]");
      // print(element["title"]);
      print(element["message"]);
      List seenUsers = element["users"];
      if (!seenUsers.contains(globalUser!.user_id!)) {
        //print("[[[[[[[[111]]]]]]]]");
        Timer(Duration(minutes: 1), () {
          showMessgeDialog(context, element["title"], element["message"],
              element["isShare"]);
          firebaseFirestore
              .collection(messages_database)
              .doc(element.id)
              .update({
            "users": FieldValue.arrayUnion([globalUser!.user_id])
          });
        });
      }
    });
  }

  showMessgeDialog(
      BuildContext context, String title, String msg, bool isShare) {
    // set up the button
    Widget okButton = MaterialButton(
      color: MColors.greenBg,
      textColor: Colors.white,
      child: Text(isShare ? "Share" : "OK"),
      onPressed: () {
        if (isShare) {
          sharePosts(shareContent);
        } else {
          Navigator.pop(context);
        }
        //UserRepo().logout(context);
      },
    );

    Widget cancel = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
        Adverts().showInterstitailOrRewarded();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          color: MColors.greenBg,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontFamily: "monestra", fontSize: 18),
          )),
      content: Text(msg),
      actions: [cancel, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
