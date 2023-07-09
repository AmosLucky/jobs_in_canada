import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repos/general_repo.dart';
import '../screens/signin.dart';
import '../screens/welcome.dart';
import '../utils/global.dart';

import '../functions/navigate.dart';
import '../models/user_model.dart';
import '../screens/main_scree.dart';
import '../utils/constants.dart';

class UserRepo extends ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  bool emailValidator(String email) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    return emailValid;
  }

  bool fieldValidator(String input) {
    return input.trim().isEmpty;
  }

  String showError(String text) {
    return text;
  }

  bool passwordValidator(String password) {
    return password.trim().length > 5;
  }

  Future<String> signin(String email, String password) async {
    String result = "";
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      if (password.trim().length >= 6) {
        try {
          UserCredential userCredential = await firebaseAuth
              .signInWithEmailAndPassword(email: email, password: password);
          String user_id = userCredential.user!.uid;
          var doc = await firebaseFirestore
              .collection(user_database)
              .doc(user_id)
              .get();
          UserModel userModel = UserModel.fromDocs(doc);
          _userModel = userModel;
          globalUser = userModel;
          notifyListeners();
          result = "success";
        } on FirebaseAuthException catch (e) {
          // String msg = e.toString();
          // if (msg == "user-already-exists") {
          //   result = "User already exists";
          // } else {
          //   result = e.toString();
          // }
          result = getMessageFromErrorCode(e.message);
        }
      } else {
        result = "Password is less than 6 characters";
      }
    } else {
      result = "Email is invalid";
    }

    return result;
  }

  Future<String> signUp(
    String email,
    String password,
    String username,
  ) async {
    String result = "";
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      if (password.trim().length >= 6) {
        try {
          UserCredential userCredential = await firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password);
          String user_id = userCredential.user!.uid;
          var doc = await firebaseFirestore
              .collection(user_database)
              .doc(user_id)
              .set({"email": email, "username": username, "user_id": user_id});
          UserModel userModel =
              new UserModel(email: email, username: username, user_id: user_id);
          _userModel = userModel;
          globalUser = userModel;
          notifyListeners();
          result = "success";
        } on FirebaseAuthException catch (e) {
          // String msg = e.toString();
          // if (msg == "user-already-exists") {
          //   result = "User already exists";
          // } else {
          //   result = e.toString();
          // }
          result = getMessageFromErrorCode(e.message);
        }
      } else {
        result = "Password is less than 6 characters";
      }
    } else {
      result = "Email is invalid";
    }

    return result;
  }

  void signInOldUser(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      signInWithId(user.uid, context);
    } else {
      //NavigateLeftToRight(context, WelcomeScreen());
      try {
        UserCredential? userCredential =
            await FirebaseAuth.instance.signInAnonymously();

        FirebaseFirestore.instance
            .collection(user_database)
            .doc(userCredential.user!.uid)
            .set({
          "username": "anonymous",
          "user_id": userCredential.user!.uid,
          "email": "anonymous0@gmail.com"
        });

        signInWithId(userCredential.user!.uid, context);
      } catch (e) {
        signInWithId(constantUserId, context);
      }
    }
  }

  void signInWithId(String user_id, BuildContext context) async {
    try {
      var doc =
          await firebaseFirestore.collection(user_database).doc(user_id).get();
      UserModel userModel = UserModel.fromDocs(doc);
      _userModel = userModel;
      globalUser = userModel;
      print(userModel.email);
      notifyListeners();
      NavigateLeftToRight(context, MainScreen());
      //GeneralRepo().navigateToScreen2(MainScreen());
    } catch (e) {
      print(user_id);
      print(e);
      //GeneralRepo().navigateToScreen2(WelcomeScreen());
      NavigateLeftToRight(context, WelcomeScreen());
    }
  }

  ////method//
  Future<UserModel> getUserData() async {
    User currentUser = firebaseAuth.currentUser!;
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection(user_database)
        .doc(currentUser.uid)
        .get();
    UserModel userModel = UserModel.fromDocs(snapshot);
    _userModel = userModel;
    notifyListeners();

    return userModel;
  }

  Future<String> update(
    String email,
    String username,
  ) async {
    String result = "";
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      try {
        var doc = await firebaseFirestore
            .collection(user_database)
            .doc(globalUser!.user_id!)
            .update({"email": email, "username": username});
        UserModel userModel = new UserModel(
            email: email, username: username, user_id: globalUser!.user_id!);
        _userModel = userModel;
        globalUser = userModel;
        notifyListeners();
        result = "success";
      } on FirebaseAuthException catch (e) {
        // String msg = e.toString();
        // if (msg == "user-already-exists") {
        //   result = "User already exists";
        // } else {
        //   result = e.toString();
        // }
        result = getMessageFromErrorCode(e.message);
      }
    } else {
      result = "Email is invalid";
    }

    return result;
  }

  logout(BuildContext context) {
    firebaseAuth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => SignIn())));
  }

  deletAccount(BuildContext context) {
    firebaseAuth.currentUser!.delete();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => SignIn())));
  }

  String getMessageFromErrorCode(e) {
    switch (e) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";

      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";

      default:
        return "Login failed. Check email and password.";
    }
  }
}
