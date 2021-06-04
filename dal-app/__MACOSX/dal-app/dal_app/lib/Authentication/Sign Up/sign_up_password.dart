import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ProportionalSizes.dart';

class SignUpPasswordPage extends StatefulWidget {

  final void Function(String) setPassword;
  final void Function(String) setConfirmedPassword;

  SignUpPasswordPage({@required this.setPassword, @required this.setConfirmedPassword});

  @override createState() => _SignUpPasswordPageState(setPassword: setPassword, setConfirmedPassword: setConfirmedPassword);
}

class _SignUpPasswordPageState extends State<SignUpPasswordPage> with AutomaticKeepAliveClientMixin {

  final void Function(String) setPassword;
  final void Function(String) setConfirmedPassword;

  bool get wantKeepAlive => true;

  _SignUpPasswordPageState({@required this.setPassword, @required this.setConfirmedPassword});

  Widget build(BuildContext context) {

    ProportionalSizes sizeManager = new ProportionalSizes(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Now we'll need you to create a password",
          style: TextStyle(
              fontSize: sizeManager.subtitleSize,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 30,),
        Text("Password", style: TextStyle(fontSize: sizeManager.labelSize, fontWeight: FontWeight.bold),),
        TextField(
          obscureText: true,
          autocorrect: false,
          decoration: InputDecoration(
            icon: Icon(Icons.lock_outline_rounded),
            hintText: "Password"
          ),
          onChanged: (password) {
            setPassword(password);
          },
        ),
        SizedBox(height: 30,),
        Text("Confirm Password", style: TextStyle(fontSize: sizeManager.labelSize, fontWeight: FontWeight.bold),),
        TextField(
          obscureText: true,
          autocorrect: false,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_rounded),
              hintText: "Confirm Password"
          ),
          onChanged: (password) {
            this.setConfirmedPassword(password);
          },
        ),
      ],
    );
  }

}