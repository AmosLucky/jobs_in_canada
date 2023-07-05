import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//import '../screens/welcome.dart';

void NavigateLeftToRight(BuildContext context, Widget child) {
  Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 500),
          child: child));
}
