import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import '../models/post_mode.dart';
import '../repos/general_repo.dart';
import '../repos/post_repo.dart';
import '../screens/post_display.dart';
import '../utils/colors.dart';
import '../utils/global.dart';
import '../widgets/display_image.dart';

import '../functions/stripHTML.dart';
import '../repos/ads_manager.dart';

class PostCard extends StatefulWidget {
  PostModel postModel;
  PostCard({super.key, required this.postModel});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  List likes = [];
  List views = [];
  String image_url = '';
  DocumentSnapshot? documentSnapshot;
  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  like() {
    PostRepo().like(widget.postModel.id.toString(), likes);
    setState(() {
      if (isLiked) {
        likes.removeLast();
      } else {
        likes.add(widget.postModel.id);
      }
      isLiked = !isLiked;
    });
  }

  initData() async {
    documentSnapshot =
        await PostRepo().createDocs(widget.postModel.id.toString());
    likes = documentSnapshot!.get("likes");
    views = documentSnapshot!.get("views");
    image_url = await PostRepo().getImage(widget.postModel.image_id.toString());
    if (likes.contains(globalUser!.user_id!)) {
      isLiked = true;
    }
    widget.postModel.image_url = image_url;
    widget.postModel.likes = likes;
    widget.postModel.views = views;
    setState(() {});
  }

  String title(String title) {
    String _title = stripHTML(title);

    if (_title.length > 60) {
      return _title.substring(0, 60) + "...";
    } else {
      // Html(
      //                         data: property_sales[0],
      //                       ),
      return _title;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Adverts().showInterstitailOrRewarded();
        PostRepo().addView(widget.postModel.id.toString(), views);
        GeneralRepo().navigateToScreen(
            context,
            PostDispaly(
              postModel: widget.postModel,
            ));
      },
      child: Container(
          height: 150,
          width: size.width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              margin: EdgeInsets.all(8),
              // color: Colors.amber,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: MColors.lighGrey),
                    child: DisplayImage(
                      url: image_url,
                    ),
                    height: 150,
                    width: size.width / 2.7,
                  ),
                  Expanded(
                      //flex: 2,
                      child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    //color: Colors.amber,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 70,
                            child: Text(
                              title(widget.postModel.title.toString()),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            // margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(),
                            child: Row(children: [
                              Icon(Icons.schedule),
                              SizedBox(
                                width: 8,
                              ),
                              Text(widget.postModel.post_date.toString())
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.remove_red_eye),
                                    Text(views.length.toString())
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () => like(),
                                        child: Icon(
                                          isLiked
                                              ? Icons.thumb_up
                                              : Icons.thumb_up_outlined,
                                          color: Colors.pink,
                                        )),
                                    Text(likes.length.toString())
                                  ],
                                )
                              ],
                            ),
                          )
                        ]),
                  ))
                ],
              ),
            ),
          )),
    );
  }
}
