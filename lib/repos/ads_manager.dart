import 'dart:convert';

//import 'package:applovin_max/applovin_max.dart';

import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:http/http.dart' as http;

import '../utils/admob_ids.dart';
import '../utils/constants.dart';
import '../widgets/show_facebook_banner.dart';

Widget fbAd = ShowFacebookBannerAd();

class Adverts {
  //int _interstitialRetryAttempt = 0;
  //int _rewardedAdRetryAttempt = 0;

  int _numRewardedLoadAttempts = 0;
  int maxFailedLoadAttempts = 5;

  int _numInterstitialLoadAttempts = 0;

  static final AdRequest request = AdRequest(
    keywords: <String>['loan', 'money', "game", "love"],
    nonPersonalizedAds: true,
  );

  void fetchAddTime() async {
    print("=========");
    var request = await http.get(Uri.parse(adsSettingUrl));
    try {
      if (request.statusCode == 200) {
        var body = jsonDecode(request.body);
        showCount = body["show_count"];

        showBannerAd = body["show_banner_ad"];
        per_post = body["per_page"];
        adType = body["ad_type"];
        AdsIds.admobRewardeAd = body["admob_rewarded"];
        AdsIds.admobInterstitial = body["admob_interstitial"];

        AdsIds.admobBannerAd = body["admob_banner"];
        //currentAppVersion = body["current_version"];
      } else {
        showCount = 3;
        showBannerAd = false;
      }
    } catch (e) {
      print(request.statusCode);
      print(e.toString());
      print("##################111");
      showCount = 3;
      showBannerAd = false;
    }
    print(showCount);
  }

  void increment() {
    showAddClick = showAddClick + 1;
  }

  void showInterstitailOrRewarded() async {
    showAddClick = showAddClick + 1;

    if (showAddClick >= showCount) {
      if (adType == "admob") {
        if (rewardedAd != null) {
          showRewardedAd();
          showAddClick = 0;
        } else if (interstitialAd != null) {
          _showInterstitialAd();
          showAddClick = 0;
        }
      } else {
        showFBInterstitialAdd();
        showAddClick = 0;
      }

      loadAllAds();
    }
  }

  loadAllAds() {
    // initAppLovinBanneBannerAds();
    // initializeInterstitialAds();
    // initializeRewardedAds();
    _createRewardedAd();
    _createInterstitialAd();
    myBanner.load();
  }

  Widget showAdmobBannerAd() {
    myBanner.load();
    print(adType);
    if (showBannerAd && adType == "admob") {
      return Container(height: 300, child: AdWidget(ad: myBanner));
    } else if (showBannerAd && adType == "facebook") {
      return fbAd;
    }

    return Container(); //AdWidget(ad: myBanner);
  }

  Widget showAdmobBigBannerAd() {
    myBanner.load();
    if (showBannerAd && adType == "admob") {
      return Container(height: 320, width: 400, child: AdWidget(ad: myBanner));
    } else if (showBannerAd && adType == "facebook") {
      return ShowFacebookBannerAd();
    }
    return Container(); //AdWidget(ad: myBanner);
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: AdsIds.admobBannerAd,
    size: AdSize.mediumRectangle,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdsIds.admobRewardeAd,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd() {
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedAd = null;
  }

  void _showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdsIds.admobInterstitial,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  showFBInterstitialAdd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "633205728765228_633229288762872",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd(delay: 2000);
      },
    );
  }

  /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////
}
