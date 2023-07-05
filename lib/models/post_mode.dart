import 'package:flutter/material.dart';

import '../repos/post_repo.dart';

class PostModel extends ChangeNotifier {
  String? title, post_date, content, image_url, job_link;
  int id, image_id;
  List views, likes;

  PostModel(
      {required this.id,
      required this.title,
      required this.image_id,
      required this.post_date,
      required this.views,
      required this.likes,
      required this.content,
      required this.image_url,
      required this.job_link}) {
    // print(this.likes);
    // print(this.views);
    // print(this.image_url);
    // initOthers();
  }
  initOthers() async {
    var documentSnapshot = await PostRepo().getPostDoc(this.id.toString());
    this.likes = documentSnapshot!.get("likes");
    this.views = documentSnapshot!.get("views");
    //this.image_url =  PostRepo().getImage(this.image_id.toString());
    notifyListeners();
    // print(this.likes);
    // print(this.views);
    // print(this.image_url);
    // if (likes.contains(globalUser!.user_id!)) {
    //   isLiked = true;
    // }
    // widget.postModel.likes = likes;
    // widget.postModel.views = views;
  }

  factory PostModel.fromJSON(Map doc) {
    return PostModel(
        id: doc["id"],
        title: doc["title"]['rendered'],
        image_id: doc["featured_media"],
        content: doc["content"]['rendered'],
        post_date: PostRepo().getDate(doc["date"]),
        views: [],
        likes: [],
        image_url: "",
        job_link: doc["excerpt"]['rendered']

        //////////////////insta
        );
  }

  // factory Post.fromDocument(DocumentSnapshot doc) {
  //   return Post(
  //     uid: doc["uid"],
  //     username: doc["username"],
  //     photoUrl: doc["photoUrl"],
  //     postId: doc["postId"],
  //     datePublished: doc["datePublished"],
  //     description: doc["description"],

  //     profileImage: doc["profileImage"],
  //     likes: doc["likes"],

  //     //////////////////insta
  //   );
  // }
}
