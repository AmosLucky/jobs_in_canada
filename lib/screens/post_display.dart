import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_launcher_icons/utils.dart';
import '../functions/stripHTML.dart';
import '../models/post_mode.dart';
import '../repos/ads_manager.dart';
import '../screens/job_page.dart';
import '../utils/colors.dart';
import '../utils/global.dart';
import '../widgets/display_image.dart';

import '../functions/share_content.dart';
import '../repos/general_repo.dart';
import '../utils/constants.dart';

class PostDispaly extends StatefulWidget {
  PostModel postModel;
  PostDispaly({super.key, required this.postModel});

  @override
  State<PostDispaly> createState() => _PostDispalyState();
}

class _PostDispalyState extends State<PostDispaly> {
  List<String> textWidget = [];
  List<Widget> body = [];
  bool hasShown = true;
  final _controller = ScrollController();
  @override
  void initState() {
    
    textWidget = widget.postModel.content!.split("[admob]");
    textWidget.forEach((element) {
      body.add(Center(
        child: Container(
          child: Adverts().showAdmobBigBannerAd(),
        ),
      ));
      body.add(Text(stripHTML(element.replaceAll("\n\n\n", "\n"))));
    });
    // Setup the listener.
    Adverts().increment();
   
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Adverts().showInterstitailOrRewarded();
        return await true;
      },
      child: Scaffold(
          backgroundColor: MColors.grey,
          floatingActionButton: FloatingActionButton(
            backgroundColor: MColors.primaryColor,
            onPressed: () {
              sharePosts(
                  stripHTML(widget.postModel.title!) + "\n" + shareContent);
            },
            child: Icon(Icons.share_sharp),
          ),
          // appBar: AppBar(
          //   foregroundColor: Colors.black,
          //   backgroundColor: Colors.white,
          //   elevation: 0,
          //   // title: Text(stripHTML(widget.postModel.title!))
          // ),
          body: SingleChildScrollView(
            controller: _controller,
            child: Stack(children: [
              Container(
                height: size.height / 2.5,
                child: DisplayImage(url: widget.postModel.image_url!),
              ),
              Container(
                width: size.width,
                //height: size.height,
                padding: EdgeInsets.all(12),
                margin:
                    EdgeInsets.only(top: size.height / 2.9, left: 5, right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    Text(
                      stripHTML(widget.postModel.title!),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Column(
                      children: body,
                    ),
                    MaterialButton(
                      onPressed: () {
                        print(stripHTML(widget.postModel.job_link!));
                        String url = stripHTML(widget.postModel.job_link!);
                        if (url.length > 4) {
                          Adverts().showInterstitailOrRewarded();
                          GeneralRepo().navigateToScreen(
                              context,
                              JobPage(
                                job_link:
                                    stripHTML(widget.postModel.job_link!) +
                                        "?title=" +
                                        widget.postModel.title! +
                                        "?image=" +
                                        widget.postModel.image_url! +
                                        "?device_token=" +
                                        deviceToken,
                              ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Something went wrong")));
                        }
                      },
                      child: Text("Apply"),
                      color: MColors.primaryColor,
                      textColor: MColors.white,
                    ),
                  ],
                ),
              ),
              Container(
                //height: 100,
                margin: EdgeInsets.only(top: size.height / 20),
                //color: Colors.amber,
                child: IconButton(
                  icon: CircleAvatar(
                      radius: 120,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      )),
                  onPressed: () {
                    Adverts().showInterstitailOrRewarded();
                    Navigator.pop(context);
                  },
                ),
              ),
            ]),
          )),
    );
  }
}
