import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/global.dart';

import '../utils/constants.dart';

class PostRepo extends ChangeNotifier {
  int _post_b4_add = 0;
  int get userModel => _post_b4_add;
  int _pageNumber = 1;
  int get pageNumber => _pageNumber;
  
  setPageNumber(int pageNumber) {
    this._pageNumber = pageNumber;
    notifyListeners();
  }

  increasePostB4Add(int i) {
    if (i == 1) {
      _post_b4_add += 1;
    } else {
      _post_b4_add = 0;
    }

    notifyListeners();
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  getDate(String date_time) {
    List dateTime = date_time.split("T");
    return dateTime[0];
  }

  Future<String> getImage(String feturedMedia) async {
    //print("kkkkoooooooooooooo");
    Response response = await http.get(Uri.parse(mediaUrl + feturedMedia));
    if (response.statusCode == 200) {
      // print("kkkkoooooooooooooo111");
      var data = jsonDecode(response.body);
      //print(data["guid"]["rendered"]);
      return data["guid"]["rendered"];
    } else {
      // print("kkkkoooooooooooooo11222");
      return "https://www.dol.gov/sites/dolgov/files/goodjobs/GoodJobsPeople.jpg";
    }
  }

  getPostDoc(String post_id) async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection(post_database).doc(post_id).get();
    return snapshot;
  }

  createDocs(String post_id) async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection(post_database).doc(post_id).get();
    Random random = Random();
    int rand = random.nextInt(300) + 100;
    int rand2 = random.nextInt(70) + 40;

    List views = [];
    List.generate(rand, (index) => views.add(index));
    List likes = [];
    List.generate(rand2, (index) => likes.add(index));

    if (!snapshot.exists) {
      await firebaseFirestore
          .collection(post_database)
          .doc(post_id)
          .set({"views": views, "likes": likes});
    }
    return getPostDoc(post_id);
  }

  getPosts(int pageNumber) async {
    try {
      Response response =
          await http.get(Uri.parse(postUrl + pageNumber.toString()));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  like(String postId, List likes) async {
    try {
      if (likes.contains(globalUser!.user_id)) {
        await firebaseFirestore.collection(post_database).doc(postId).update({
          "likes": FieldValue.arrayRemove([globalUser!.user_id])
        });
      } else {
        await firebaseFirestore.collection(post_database).doc(postId).update({
          "likes": FieldValue.arrayUnion([globalUser!.user_id])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  addView(String postId, List views) async {
    try {
      if (!views.contains(globalUser!.user_id)) {
        await firebaseFirestore.collection(post_database).doc(postId).update({
          "views": FieldValue.arrayUnion([globalUser!.user_id])
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
