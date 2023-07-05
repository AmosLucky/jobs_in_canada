import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repos/ads_manager.dart';
import '../repos/user_repo.dart';
import '../utils/colors.dart';
import '../utils/global.dart';

import '../widgets/roundbutton.dart';
import '../widgets/text_input.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();
  var usernameController = new TextEditingController();
  String msg = "";
  bool isLoding = false;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController.text = globalUser!.email!;
    usernameController.text = globalUser!.username!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserRepo userRepo = context.watch<UserRepo>();
    return WillPopScope(
      onWillPop: ()async {
        Adverts().showInterstitailOrRewarded();
        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MColors.primaryColor,
          elevation: 0,
          centerTitle: true,
          title: Text(globalUser!.username!),
          actions: [
            IconButton(
                onPressed: () {
                  showdeleteDialog(context);
                },
                icon: Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  showLogoutDialog(context);
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 100, horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(children: [
                CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: textInput(
                      controller: usernameController,
                      labelText: "Enter your username",
                      isPassword: false,
                      textInputType: TextInputType.text,
                      icon: Icons.person,
                      validator: (text) {
                        if (userRepo.fieldValidator(text!)) {
                          return userRepo.showError("Empty field");
                        }
                      }),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: textInput(
                      controller: emailController,
                      labelText: "Enter your email",
                      isPassword: false,
                      textInputType: TextInputType.emailAddress,
                      icon: Icons.email,
                      validator: (text) {
                        if (!userRepo.emailValidator(text!)) {
                          return userRepo.showError("Invalid email");
                        }
                      }),
                ),
                Visibility(
                    child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    msg,
                    style: TextStyle(color: Colors.red),
                  ),
                )),
                Visibility(
                    visible: isLoding,
                    child: Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: LinearProgressIndicator())),
                SizedBox(
                  height: 25,
                ),
                roundButton(
                    context: context,
                    bgColor: MColors.primaryColor,
                    text: "Update",
                    textColor: Colors.white,
                    onTap: () async {
                      print("ll");
                      if (_formKey.currentState!.validate()) {
                        print("ll00");
                        var email = emailController.text;
                        //var password = passwordController.text;
                        var username = usernameController.text;
                        setState(() {
                          isLoding = true;
                          msg = "";
                        });
                        msg = await UserRepo().update(email, username);
                        print(msg);
                        if (msg == "success") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Success")));
                          //NavigateLeftToRight(context, MainScreen());
                        }
                        isLoding = false;
                        setState(() {});
                      }
                    }),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  showLogoutDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        UserRepo().logout(context);
      },
    );
    Widget cancel = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("You are about to logout"),
      actions: [okButton, cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showdeleteDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        UserRepo().deletAccount(context);
      },
    );
    Widget cancel = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account"),
      content: Text("You are about to delete this account"),
      actions: [okButton, cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
