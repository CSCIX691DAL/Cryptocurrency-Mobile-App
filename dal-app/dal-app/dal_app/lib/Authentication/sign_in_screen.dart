import 'package:dal_app/Authentication/Sign%20Up/sign_up_screen.dart';
import 'package:dal_app/Authentication/password_recovery.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dallogo_back_button.dart';

class SignInScreen extends StatefulWidget {

  SignInScreen({@required this.createAccount});
  @override
  VoidCallback createAccount;
  State<StatefulWidget> createState() => _SignInScreenState(callback: createAccount);
}

class _SignInScreenState extends State<SignInScreen> {
  VoidCallback callback;

  _SignInScreenState({@required this.callback});

  void signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    );
    print(FirebaseAuth.instance.currentUser.email);
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    double titleSize = 40;
    double padding = 40;
    double height = MediaQuery.of(context).size.height;
    if(height < 700) {
      titleSize = 30;
      padding = 20;
    }
    return StreamBuilder<Object>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return FullScreenLoader();
        }
        return SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 600,
                ),
                child: SizedBox(
                  height: height,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DalLogoBackButton(onPressed: (){}),
                        SizedBox(height: 20,),
                        Text("Sign In", style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            TextField(
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  icon: Icon(Icons.email)),
                            )
                          ],
                        ),
                        SizedBox(height: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            TextField(
                              obscureText: true,
                              autocorrect: false,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  icon: Icon(Icons.lock)
                              ),
                            ),
                            TextButton(onPressed: ()=>{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordRecoveryScreen())),
                            }, child: Text(
                              "Forgot Your Password?"
                            ))
                          ],
                        ),
                        Spacer(flex: 1),
                        SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: MaterialButton(
                              onPressed: ()=>signIn(),
                              child: Text("Sign In", style: TextStyle(fontSize: 20),),
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                            )
                        ),
                        Spacer(),
                        Divider(),
                        Spacer(),
                        Text("No Account?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: OutlinedButton(
                                onPressed: ()=>{
                                  this.callback()
                                },
                                child: Text("CREATE ACCOUNT"),
                              )
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ),
            ),
        );
      }
    );
  }

}