import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/Authentication/Sign%20Up/sign_up_button.dart';
import 'package:dal_app/Authentication/Sign%20Up/sign_up_confirm.dart';
import 'package:dal_app/Authentication/Sign%20Up/sign_up_password.dart';
import 'package:dal_app/Authentication/Sign%20Up/sign_up_personal_info.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:dal_app/Misc.%20Views/page_dots.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ProportionalSizes.dart';
import '../dallogo_back_button.dart';

class SignUpScreen extends StatefulWidget {

  VoidCallback back;

  SignUpScreen({@required this.back});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState(back: back);
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  @override

  int currentPage = 0;
  final dotCount = 3;
  TabController _tabController;
  VoidCallback back;

  String email = "";
  String name = "";
  String password = "";
  String confirmedPassword = "";

  bool isLoading = false;

  _SignUpScreenState({@required this.back});

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  Widget build(BuildContext context) {

    _tabController.addListener(() {
      setState(() {
        currentPage = _tabController.index;
      });
    });

    ProportionalSizes sizeManager = new ProportionalSizes(context);
    double height = MediaQuery.of(context).size.height;

    ScrollPhysics swipe = NeverScrollableScrollPhysics();

    void pageUp() {
      setState(() {
        if(currentPage+1 < dotCount) {
          this.currentPage += 1;
          _tabController.animateTo(currentPage);
        }
      });
    }

    bool verifyEmail() {
      return !email.isEmpty && email.contains("@") && email.contains(".");
    }

    bool verifyName() {
      return name.length > 3;
    }

    bool verifyPassword() {
      return password.isNotEmpty && password.length >= 6;
    }

    bool verifyConfirmedPassword() {
      return confirmedPassword == password;
    }

    Future<void> signUpUser(String email, String password, String name) async {
        UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance.collection("users").doc(user.user.uid).set(
            {
              "name" : name,
              "email" : email,
              "firstAuth": true
            }
        );
        await FirebaseFirestore.instance.collection("users").doc(user.user.uid).collection("coins").doc("init").set(
          {"exists" : true}
        );
    }

    return SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 520
            ),
            child: SizedBox(
              height: height - MediaQuery.of(context).padding.vertical,
              child: Padding(
                padding: EdgeInsets.all(sizeManager.padding),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DalLogoBackButton(onPressed: back),
                          SizedBox(height: 20,),
                          Text("Sign Up", style: TextStyle(fontSize: sizeManager.titleSize, fontWeight: FontWeight.bold),),
                          SizedBox(height: 30,),
                          SizedBox(
                            height: sizeManager.labelSize == 20 ? 330 : 240,
                            child: TabBarView(
                                physics: swipe,
                                controller: _tabController,
                                children: [
                                  SignUpPersonalInfoPage(setName: (String name){
                                    setState(() {
                                      this.name = name;
                                    });
                                  }, setEmail: (String email){
                                    setState(() {
                                      this.email = email;
                                    });
                                  }),
                                  SignUpPasswordPage(
                                    setPassword: (String password){
                                      this.setState(() {
                                        this.password = password;
                                      });
                                    },
                                    setConfirmedPassword: (String password) {
                                      this.confirmedPassword = password;
                                    },
                                  ),
                                  SignUpConfirmPage(name: this.name, email: this.email, password: this.password,)
                                ]
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: PageDots(dotCount: dotCount, selectedIndex: currentPage, spacing: 5,),
                          ),
                          if(currentPage > 0)
                            TextButton(onPressed: (){
                              _tabController.animateTo(currentPage-1);
                              currentPage = _tabController.index;
                            }, child: Text("Previous")),
                          if(currentPage == 0)
                            Text("  "),
                          SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: SignUpButton(
                                action: () {
                                  if(currentPage == 0) {
                                    if(verifyEmail() && verifyName()) {
                                      pageUp();
                                    }
                                  } else if(currentPage == 1) {
                                    if(verifyPassword() && verifyConfirmedPassword()) {
                                      pageUp();
                                    }
                                  }
                                },
                                finalAction: () async {
                                  setState(() {
                                    this.isLoading = true;
                                  });
                                  try {
                                    await signUpUser(email, password, name);
                                  } catch(error) {
                                    this.setState(() {
                                      this.isLoading = false;
                                    });
                                  }
                                },
                                currentIndex: currentPage,
                                maxIndex: dotCount-1,
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

}