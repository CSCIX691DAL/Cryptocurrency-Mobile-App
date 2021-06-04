import 'package:dal_app/ProportionalSizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpConfirmPage extends StatelessWidget {

  String name;
  String email;
  String password;

  SignUpConfirmPage({@required this.name, @required this.email, @required this.password});

  String getObscuredPassword() {
    String obscuredPassword = "";
    for(int i=0; i<password.length; i++) {
      obscuredPassword += "*";
    }
    return obscuredPassword;
  }

  Widget build(BuildContext context) {

    String displayPassword;
    ProportionalSizes sizeManager = new ProportionalSizes(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("That was easy, wasn't it?",
          style: TextStyle(
              fontSize: sizeManager.subtitleSize,
              fontWeight: FontWeight.bold
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("Press the button below to confirm your account"),
        ),
        SizedBox(height: 30,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text("Name", style: TextStyle(fontSize: sizeManager.labelSize, fontWeight: FontWeight.bold),),
            ),
            Text(name, style: TextStyle(fontSize: 18),)
          ],
        ),
        SizedBox(height: 30,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text("Email", style: TextStyle(fontSize: sizeManager.labelSize, fontWeight: FontWeight.bold),),
            ),
            Text(email, style: TextStyle(fontSize: 18),)
          ],
        ),
        SizedBox(height: 30,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text("Password", style: TextStyle(fontSize: sizeManager.labelSize, fontWeight: FontWeight.bold),),
            ),
            Text(getObscuredPassword(), style: TextStyle(fontSize: 18),)
          ],
        ),
        Spacer(),
      ],
    );
  }

}