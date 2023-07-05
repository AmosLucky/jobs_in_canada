import 'dart:io';

import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';

class ShowFacebookBannerAd extends StatelessWidget {
  const ShowFacebookBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0.5, 1),
      child: FacebookBannerAd(
        placementId: Platform.isAndroid
            ? "633205728765228_633229288762872"
            : "YOUR_IOS_PLACEMENT_ID",
        bannerSize: BannerSize.MEDIUM_RECTANGLE,
        listener: (result, value) {
          switch (result) {
            case BannerAdResult.ERROR:
              print("Error: $value");
              break;
            case BannerAdResult.LOADED:
              print("Loaded: $value");
              break;
            case BannerAdResult.CLICKED:
              print("Clicked: $value");
              break;
            case BannerAdResult.LOGGING_IMPRESSION:
              print("Logging Impression: $value");
              break;
          }
        },
      ),
    );
  }
}
