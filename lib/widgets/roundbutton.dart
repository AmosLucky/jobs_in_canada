import 'package:flutter/material.dart';
import '../utils/dimensions.dart';

Widget roundButton(
    {required BuildContext context,
    Color? bgColor,
    String? text,
    Color? textColor,
    Function()? onTap}) {
  return Container(
    width: Dimentions.getSize(context).width / 1.5,
    height: Dimentions.getSize(context).width / 8,
    child: MaterialButton(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: onTap,
      child: Text(
        text!,
        style: TextStyle(fontSize: 16),
      ),
      textColor: textColor,
      color: bgColor,
    ),
  );
}
