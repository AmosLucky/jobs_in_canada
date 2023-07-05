import 'package:google_mobile_ads/google_mobile_ads.dart';

String appName = "Jobs in Canada";
String slogan = "Jobs in Canada, Find your perfect job";
String baseurl = "https://www.travelto.amoschibueze.com/";
String mediaUrl = baseurl + "wp-json/wp/v2/media/";
String postUrl = baseurl + "wp-json/wp/v2/posts/?per_page=100&page=";
String user_database = "jobs_in_canada_users";
String post_database = "jobs_in_canada_posts";
String messages_database = "jobs_in_canada_messages";
String adsSettingUrl =
    "https://travelto.amoschibueze.com/json/settings.php?type=2";
//////////////////////////////
/////////////////////////////
////////////////////////////
int showAddClick = 0;
int showCount = 3;
int per_post = 5;
bool showBannerAd = false;
InterstitialAd? interstitialAd;
RewardedAd? rewardedAd;
double appVersion = 2.0;
String adType = "admob";

String appUrl =
    "https://play.google.com/store/apps/details?id=com.example.jobs_in_canada";
String shareContent =
    "*Workers needed in Canada 🇨🇦, USA 🇺🇸,Mexico 🇲🇽,Australia 🇦🇺 Salary from \$10,000 - \$100,000* \n" +
        appName +
        ''' is an app where you can search and get foreign jobs.
    The good news is that some of this jobs has sponsored visa to travel abroad
    and the companies are willing to pay for your visa. 
      Install the app with the link below and start applying ''' +
        appUrl;

String constantUserId = "xTqb32HpJIVHI3aqIh2pEi9RPdW2";
String save_device_token = baseurl + "json/save_device_token.php?type=2";
