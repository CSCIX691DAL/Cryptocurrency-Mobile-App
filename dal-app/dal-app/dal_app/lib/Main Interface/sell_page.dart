import 'package:dal_app/Authentication/sign_in_screen.dart';
import 'package:dal_app/Main%20Interface/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'buy_page.dart';
import 'dart:convert';
import 'package:dal_app/Main%20Interface/buy_page.dart';
import 'package:dal_app/Main%20Interface/portfolio.dart';
import 'package:dal_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'home_page.dart';

import 'package:flutter/material.dart';

class SellPage extends StatelessWidget {

  final Map currency;


  final sellController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser.uid;

  var userBalance = 0;

  SellPage(this.currency);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Sell Coins"),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 26.0,
              ),
            ),

            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right:20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                        Icons.more_vert
                    ),
                  )
              ),
            ]
        ),


        body: Center(
            child: Column( children: <Widget>[
              Container(
                margin: const EdgeInsets.all(30.0),
                width: 350,
                height: 200,
                child: CircleAvatar(
                  child: Image.network(currency['image']),
                ),
              ),

              Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.black54.withOpacity(0.1),
                  width: 175,
                  height: 60,
                  child: Center(
                      child: Text(currency['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.withOpacity(1.0),
                            fontSize: 25,
                          )
                      )
                  )
              ),


              Container(
                margin: const EdgeInsets.all(10.0),
                color: Colors.black54.withOpacity(0.1),
                width: 175,
                child: TextField(
                  controller: sellController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "\$0.00",
                  ),
                ),
              ),


              OutlinedButton(
                  child: Text("Sell " + currency['name'] + " Currency"),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text('Crypto Currency Sold!')
                      ),
                    );
                    getUserBalance();
                    Timer(Duration(seconds: 2), () {
                      sellWriteToDB(checkExistingEntry(), userBalance);
                    });

                  }


              )
            ]
            )
        )


    );
  }

  bool checkExistingEntry() {
    var checkExisting = true;

    CollectionReference coinReference = FirebaseFirestore.instance.collection("users").doc(currentUser).collection("coins");
    coinReference.get().then((QuerySnapshot querySnapshot){

      querySnapshot.docs.forEach((doc) {

        if (doc["name"].toString() == currency["name"].toString()) {
          checkExisting = true;


        }
        else{
          checkExisting = false;
        }
      });
    });
    return checkExisting;

  }

  Future<int> getUserBalance() async{

    CollectionReference coinReference = await FirebaseFirestore.instance.collection("users").doc(currentUser).collection("coins");
    coinReference.get()
        .then((QuerySnapshot balanceSnapshot){
      balanceSnapshot.docs.forEach((doc) {

        if(doc["name"].toString() == currency["name"].toString()){
          userBalance = doc["balance"];


        }


      });
    });

  }



  sellWriteToDB(checkExisting, userBalance){

    CollectionReference coinReference = FirebaseFirestore.instance.collection("users").doc(currentUser).collection("coins");


    int controllerInt = int.parse(sellController.text);

    if (userBalance < 0){
      userBalance = 0;
    }
    if(controllerInt < 0){
      controllerInt = 0;
    }
    int totalBalance = (userBalance - controllerInt);
    if(totalBalance < 0){
      totalBalance = 0;
    }


    coinReference.doc(currency["name"]).update({"balance" : totalBalance});

    if (checkExistingEntry() == false){
      print("You do not own this currency");
    }

  }
}