import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/Main%20Interface/buy_page.dart';
import 'package:dal_app/Main%20Interface/portfolio.dart';
import 'package:dal_app/Main%20Interface/sell_page.dart';
import 'package:dal_app/Main%20Interface/Buy_page.dart';
import 'package:dal_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';
import 'package:dal_app/Authentication/sign_in_screen.dart';

class BuyPage extends StatelessWidget {

  final Map currency;

  BuyPage(this.currency);



  final myController = TextEditingController();


  void dispose() {
    myController.dispose();
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 2), () => {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Buy Coins"),
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
                  controller: myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "\$0.00",
                  ),
                ),
              ),

              OutlinedButton(
                  child: Text("Buy " + currency['name'] + " Currency"),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: Text(myController.text)
                      ),
                    );
                    //deleteAll();
                    buyWriteToDB(checkExistingEntry());
                  }

              )
            ]
            )
        )


    );
  }
  bool checkExistingEntry() {
    var currentUserID = FirebaseAuth.instance.currentUser.uid;
    var checkExisting = false;
    CollectionReference coinReference = FirebaseFirestore.instance.collection("users").doc(currentUserID).collection("coins");
    coinReference.limit(1).get().then((QuerySnapshot querySnapshot){

      querySnapshot.docs.forEach((doc) {
        if (doc["name"].toString() == currency["name"].toString()) {
          checkExisting = true;
          print(checkExisting);

        }
        else {
          checkExisting = false;

       }

      });
    });
    return checkExisting;
  }

  void buyWriteToDB(checkExisting) async{
    print(checkExisting);
    var currentUserID = FirebaseAuth.instance.currentUser.uid;
    CollectionReference coinReference = await FirebaseFirestore.instance.collection("users").doc(currentUserID).collection("coins");
    if(myController.text.isEmpty){
      myController.text = "0";
    }

    if(checkExisting == false){
      //Map<String, dynamic> data = {"name" : currency["name"], "symbol": currency["symbol"], "image" : currency["image"], "balance" : myController.text};
      return coinReference
          .doc(currency["name"].toString())
          .set({"name" : currency["name"], "symbol": currency["symbol"], "image" : currency["image"], "balance" : myController.text
          });

      //coinReference.add(data);
    }
    else{
      coinReference
          .doc(currency["name"])
          .update({"balance" : myController.text});

    }
  }

  void deleteAll() async{
    var currentUserID = FirebaseAuth.instance.currentUser.uid;

    FirebaseFirestore.instance.collection("users").doc(currentUserID)
        .collection("coins").get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    });
  }

}