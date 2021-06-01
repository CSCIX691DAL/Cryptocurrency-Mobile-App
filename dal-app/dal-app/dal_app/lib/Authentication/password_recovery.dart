import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dallogo_back_button.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {

  String email;
  final _formKey = GlobalKey<FormState>();
  final emailTextController = new TextEditingController();
  final emailRegex = RegExp("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}");

  Future<bool> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailTextController.text);
    } catch(error) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(error.message),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context, true);
            }, child: Text("Ok"))
          ],
        );
      });
      return false;
    }
    return true;
  }


  Widget build(BuildContext context) {
    double titleSize = 40;
    double padding = 40;
    double height = MediaQuery.of(context).size.height;
    if(height < 700) {
      titleSize = 30;
      padding = 20;
    }
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 600,
              ),
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DalLogoBackButton(onPressed: (){
                          Navigator.pop(context, true);
                        }),
                        SizedBox(height: 20,),
                        Text("Reset Password", style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),
                        Text("Enter your email in the field provided below. We will send you an email with instructions to reset your password."),
                        SizedBox(height: 30,),
                        TextFormField(
                        controller: emailTextController,
                        decoration: InputDecoration(
                            labelText: "Email",
                            icon: Icon(Icons.email)),
                        validator: (value) {
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50,),
                      SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a Snackbar.
                                var result = await resetPassword();
                                if(result) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text('Email Sent!')));
                                }
                              }
                            },
                            child: Text("Send", style: TextStyle(fontSize: 20),),
                          )
                      ),
                    ],
                ),
                  ),
              ),
            ),
        ),
          )
      )
    );
  }
}