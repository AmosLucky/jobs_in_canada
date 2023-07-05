import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';

import '../utils/colors.dart';

showAlertDialogUPdate(
  BuildContext context,
  String title,
  String message,
) {
  // set up the button

  // show the dialog
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: MColors.primaryColor),
          ),
          content: Text(message),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                LaunchReview.launch(
                    androidAppId: "com.casoftech.jobs_in_canada", iOSAppId: "585027354");
                SystemNavigator.pop();
                Navigator.pop(context);
                
              },
              child: Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}
