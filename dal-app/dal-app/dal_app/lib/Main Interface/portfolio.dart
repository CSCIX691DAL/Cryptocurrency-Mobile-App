import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/Main%20Interface/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dal_app/Main%20Interface/buy_page.dart';
import 'package:dal_app/Main%20Interface/main.dart';
import 'package:dal_app/Main%20Interface/portfolio.dart';
import 'package:dal_app/Main%20Interface/sell_page.dart';
import 'package:dal_app/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'home_page.dart';
class PortfolioPage extends StatefulWidget {

  final List currencies;
  PortfolioPage(this.currencies);

  var results = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).get();

  // const HomePage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => new _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  var results;
  List currencies;
  var currentUser = FirebaseAuth.instance.currentUser.uid;
  _PortfolioPageState();


  //final List<MaterialColor> _colors = [Colors.amber, Colors.blueGrey, Colors.indigo];
  Future getUserCurrency() async {
    var coinReference = FirebaseFirestore.instance.collection("users").doc(
        FirebaseAuth.instance.currentUser.uid).collection("coins");

    QuerySnapshot coin = await coinReference.get();

    return coin;
  }
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          title: Text("Portfolio",
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
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(
                currentUser).collection("coins").snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document){
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.network(document["image"]),
                    ),
                    title: Text(document['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: _userAmount(document["balance"], document["symbol"]),
                  );

                }).toList(),
              );
            }
        ),
      ),
    );

  }

  Widget _userAmount(int priceUSD, String symbol){
    TextSpan priceTextWidget = TextSpan(
        text: priceUSD.toString() + " " + symbol + "    ", style: TextStyle(color: Colors.black, fontSize: 22));

    return RichText(
        text: TextSpan(
            children: [priceTextWidget]
        )
    );
  }

  Future<List> getCurrencies() async{
    String cryptoUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false";
    http.Response response = await http.get(Uri.parse(cryptoUrl));
    return jsonDecode(response.body);
  }
  Future <MyApp> _signOut()  async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
    return new MyApp();
  }

  void choiceAction (String choice){
    if(choice == Constants.profilePage){
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
    else if(choice == Constants.signOut){
      _signOut();
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