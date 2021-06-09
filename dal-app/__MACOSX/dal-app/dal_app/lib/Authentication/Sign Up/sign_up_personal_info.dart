import 'package:dal_app/ProportionalSizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPersonalInfoPage extends StatefulWidget {

  final void Function(String) setName;
  final void Function(String) setEmail;

  SignUpPersonalInfoPage({@required this.setName, @required this.setEmail});
  @override
  createState() => _SignUpPersonalInfoPageState(setName: setName, setEmail: setEmail);

}

class _SignUpPersonalInfoPageState extends State<SignUpPersonalInfoPage> with AutomaticKeepAliveClientMixin {

  final void Function(String) setName;
  final void Function(String) setEmail;

  bool get wantKeepAlive => true;

  _SignUpPersonalInfoPageState({@required this.setName, @required this.setEmail});

  Widget build(BuildContext context) {

    ProportionalSizes sizeManager = new ProportionalSizes(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("First, we'll need a bit of personal info",
          style: TextStyle(
              fontSize: sizeManager.subtitleSize,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 30,),
        Text("Email", style: TextStyle(fontSize: sizeManager.labelSize, fontWeight: FontWeight.bold),),
        TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.email),
            hintText: "Email"
          ),
          onChanged: (email) {
            setEmail(email);
          },
        ),
        SizedBox(height: 30,),
        Text("Name", style: TextStyle(fontSize: sizeManager.labelSize, fontWeight: FontWeight.bold),),
        TextField(
            decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Name"
            ),
            onChanged: (name) {
              setName(name);
            },
        )
      ],
    );
  }

}