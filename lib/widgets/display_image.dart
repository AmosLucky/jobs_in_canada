import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class DisplayImage extends StatelessWidget {
  String url;
  DisplayImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
        color: MColors.whitBg,
      )),
      errorWidget: (context, url, error) => Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          "assets/images/image_holder.jpg",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
