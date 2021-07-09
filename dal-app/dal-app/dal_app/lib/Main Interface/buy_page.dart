
import 'package:dal_app/Main%20Interface/profile_page.dart';
import 'package:dal_app/Main%20Interface/sell_page.dart';
import 'package:flutter/material.dart';
import 'package:dal_app/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../constants.dart';

class BuyPage extends StatefulWidget {
  VoidCallback advance;

  BuyPage({@required this.advance});

  @override
  State<StatefulWidget> createState() => _BuyPageState(advance: advance);
}

class _BuyPageState extends State<BuyPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  VoidCallback advance;

  bool get wantKeepAlive => true;

  _BuyPageState({@required this.advance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Buy Coins",
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


        body: Center(
            child: Column( children: <Widget>[
              Container(
                margin: const EdgeInsets.all(30.0),
                width: 350,
                height: 200,
                child: CircleAvatar(
                  // child: Image.network(currency['image']), commented this out to make code work
                ),
              ),

              Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.black54.withOpacity(0.1),
                  width: 175,
                  height: 60,
                  child: Center(
                      child: Text("Bitcoin -- BTC",
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "\$0.00",
                  ),
                ),
              ),

              OutlinedButton(
                  child: Text("Buy Crypto Currency"),
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text('Crypto Currency Purchased!')
                      )
                  )
              )
            ]
            )
        )


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

    }
  }
}