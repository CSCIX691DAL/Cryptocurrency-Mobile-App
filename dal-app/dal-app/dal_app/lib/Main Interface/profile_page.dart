import 'dart:convert';
import 'dart:io';
import 'package:dal_app/Main%20Interface/buy_page.dart';
import 'package:dal_app/Main%20Interface/main.dart';
import 'package:dal_app/Main%20Interface/portfolio.dart';
import 'package:dal_app/Main%20Interface/sell_page.dart';
import 'package:dal_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'package:dal_app/Authentication/sign_in_screen.dart';


class ProfileScreen extends StatefulWidget {
  VoidCallback advance;

  ProfileScreen({@required this.advance});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState(advance: advance);
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  VoidCallback advance;


  bool get wantKeepAlive => true;

  _ProfileScreenState({@required this.advance});

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Profile",
            style: TextStyle(
            color: Colors.black,
          ),
          ),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
                size: 40,
              ),
              onSelected: choiceAction ,
              itemBuilder: (BuildContext context){
                return Constants.choices.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),

        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 120,
                  backgroundImage: _image != null ? FileImage(_image) : null,
                  child: _image == null ? Text("Picture") : null,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
              alignment: Alignment.center,
              child: ElevatedButton(
                child: Text("Change image"),
                onPressed: () {
                  getImage();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(width: 50,
                child: Text('Name: Test', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(width: 50,
                child: Text("Email: " + FirebaseAuth.instance.currentUser.email, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void choiceAction (String choice){
    if(choice == Constants.sellPage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SellPage()),
      );
    }
    else if(choice == Constants.buyPage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BuyPage()),
      );
    }
    else if(choice == Constants.profilePage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
    else if(choice == Constants.homePage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SwapToHome()),
      );
    }
    else if(choice == Constants.portfolioPage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SwapToPortfolio()),
      );
    }
  }
  SwapToPortfolio() async {
    List currencies = await getCurrencies();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PortfolioPage(currencies)),
    );
  }
  SwapToHome() async {
    List currencies = await getCurrencies();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(currencies)),
    );
  }
}

