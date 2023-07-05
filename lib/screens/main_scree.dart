import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../functions/share_content.dart';
import '../models/post_mode.dart';
import '../repos/general_repo.dart';
import '../repos/post_repo.dart';
import '../screens/profile.dart';
import '../screens/signup.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/opacity_bg.dart';
import '../repos/ads_manager.dart';
import '../utils/global.dart';
import '../widgets/banner_ad.dart';
import '../widgets/post_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    showAds();

    GeneralRepo().checkUpdate(context, "Update Available",
        "Please update this app to enjoy a better job search experience");
    GeneralRepo().showMessge(context);

    // TODO: implement initState
    super.initState();
  }

  final scrollController = ScrollController();

  void showAds() {
    Timer(Duration(seconds: 5), () {
      Adverts().showInterstitailOrRewarded();
    });
  }

  @override
  Widget build(BuildContext context) {
    PostRepo postRepo = context.watch<PostRepo>();
    Size size = MediaQuery.of(context).size;

    //print(globalUser!.email);
    return WillPopScope(
      onWillPop: () async {
        Adverts().showInterstitailOrRewarded();
        return await false;
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: MColors.primaryColor,
            onPressed: () {
              //print("ooo");
              sharePosts(shareContent);
            },
            child: Icon(Icons.share_sharp),
          ),
          backgroundColor: MColors.whitBg,
          appBar: AppBar(
            backgroundColor: MColors.primaryColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            // centerTitle: true,
            title: Text(
              "Get a perfect job",
              style: TextStyle(fontFamily: "Monestra"),
            ),
            actions: [
              Container(
                  child: IconButton(
                onPressed: () {
                  sharePosts(shareContent);
                },
                icon: Icon(Icons.share),
              )),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () {
                      Adverts().showInterstitailOrRewarded();
                      if (globalUser!.username! == "anonymous") {
                        GeneralRepo().navigateToScreen(context, SignUp());
                      } else {
                        GeneralRepo().navigateToScreen(context, Profile());
                      }
                    },
                    child: CircleAvatar(
                      radius: 15,
                      child: Icon(Icons.person),
                    )),
              ),
            ],
          ),
          body: OpacityBg(
            context,
            RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                // var newRoute =
                //     MaterialPageRoute(builder: ((context) => MainScreen()));
                // Navigator.of(context).pushReplacement(newRoute);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: FutureBuilder(
                  future: PostRepo().getPosts(PostRepo().pageNumber),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      EasyLoading.show(status: 'loading...');
                      return Center(
                          child: CircularProgressIndicator(
                        color: MColors.primaryColor,
                      ));
                    }
                    if (snapshot.hasError) {
                      EasyLoading.showError(
                          'Failed with Error. Please refresh');
                      return Center(
                          child: Text(
                        "Error occoured",
                        style: TextStyle(color: Colors.black),
                      ));
                    }
                    if (!snapshot.hasData) {
                      EasyLoading.showError(
                          'Failed with Error. Please refresh');
                      return Center(child: Text("No data"));
                    }
                    EasyLoading.dismiss();
                    List list = snapshot.data as List;
                    int post_per_ad = 0;

                    return SingleChildScrollView(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            PostModel postModel =
                                PostModel.fromJSON(list[index]);
                            if (post_per_ad == per_post) {
                              //print("======");
                              post_per_ad = 0;
                              return Column(
                                children: [
                                  PostCard(
                                    postModel: postModel,
                                  ),
                                  BannerAdWidget(),
                                ],
                              );
                            } else {
                              post_per_ad += 1;
                              //print(post_per_ad);
                              return PostCard(
                                postModel: postModel,
                              );
                            }
                          }),
                    );
                  },
                ),
              ),
            ),
          )),
    );
  }
}
