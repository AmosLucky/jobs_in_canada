import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class textInput extends StatefulWidget {
  String labelText;
  TextInputType textInputType;
  TextEditingController controller;
  bool isPassword;
  IconData icon;
  String? Function(String?)? validator;

  //Function validator;

  textInput({
    Key? key,
    required this.labelText,
    required this.textInputType,
    required this.isPassword,
    required this.controller,
    required this.icon,
    required this.validator

    //required this.validator
  }) : super(key: key);

  @override
  State<textInput> createState() => _textInputState();
}

class _textInputState extends State<textInput> {
  @override
  bool passwordNotShowing = true;

  void initState() {
    // print(passwordShowing && widget.isPassword);
    // passwordShowing = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimentions.getSize(context).width / 1.5,
      child: TextFormField(
        keyboardType: widget.textInputType,
        obscureText: (passwordNotShowing && widget.isPassword),
        controller: widget.controller,
        cursorColor: MColors.primaryColor,
        style: TextStyle(color: MColors.primaryColor),
        validator: widget.validator,
        decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: Icon(
              widget.icon,
              color: MColors.primaryColor,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        passwordNotShowing = !passwordNotShowing;
                      });
                    },
                    icon: Icon(passwordNotShowing
                        ? Icons.remove_red_eye
                        : Icons.visibility_off))
                : null,
            focusedBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: MColors.primaryColor))),
      ),
    );
  }
}
