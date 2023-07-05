import 'package:flutter/material.dart';
import '../repos/ads_manager.dart';
import '../utils/constants.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return showBannerAd
        ? Container(
            //height: 300,
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text("Ads"),
                ),
                Divider(
                  height: 0.5,
                ),
                Adverts().showAdmobBigBannerAd()
              ]),
            ),
          )
        : Container();
  }
}
