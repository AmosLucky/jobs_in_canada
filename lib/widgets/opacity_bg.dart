import 'package:flutter/material.dart';
import '../utils/colors.dart';

import '../utils/assets.dart';
import '../utils/dimensions.dart';

Widget OpacityBg(BuildContext context, Widget body) {
  return Stack(
    children: [
      Container(
        width: Dimentions.getSize(context).width,
        height: Dimentions.getSize(context).height,

        // color: Colors.amber,
        child: Image.asset(
          GetAssts.getBgImage(),
          fit: BoxFit.fill,
        ),
      ),
      Container(
        width: Dimentions.getSize(context).width,
        height: double.infinity,
        // height: Dimentions.getSize(context).height,
        decoration: BoxDecoration(
          color: AppTheme.lightBg.withOpacity(0.75),
        ),
        child: body,
      )
    ],
  );
}
